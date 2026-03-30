import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY;

/**
 * POST /api/shops/photo
 * Fetch Google Places photo for a shop and update the database
 *
 * Body: { shopId: string }
 */
export async function POST(request: NextRequest) {
  try {
    const { shopId } = await request.json();

    if (!shopId) {
      return NextResponse.json(
        { error: "shopId is required" },
        { status: 400 },
      );
    }

    if (!API_KEY) {
      return NextResponse.json(
        { error: "Google Maps API key not configured" },
        { status: 500 },
      );
    }

    const supabase = await createClient();

    // Get shop data
    const { data: shop, error: fetchError } = await supabase
      .from("shops")
      .select("id, name, lat, lng, google_place_id, google_photo_url")
      .eq("id", shopId)
      .single();

    if (fetchError || !shop) {
      return NextResponse.json({ error: "Shop not found" }, { status: 404 });
    }

    // If already has photo URL, return it
    if (shop.google_photo_url) {
      return NextResponse.json({
        success: true,
        photoUrl: shop.google_photo_url,
        cached: true,
      });
    }

    // Step 1: Find Place ID if not exists
    let placeId = shop.google_place_id;

    if (!placeId) {
      const query = encodeURIComponent(shop.name);
      const findUrl = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${query}&inputtype=textquery&locationbias=circle:500@${shop.lat},${shop.lng}&fields=place_id&key=${API_KEY}`;

      const findRes = await fetch(findUrl);
      const findData = await findRes.json();

      if (findData.candidates?.[0]?.place_id) {
        placeId = findData.candidates[0].place_id;
      }
    }

    if (!placeId) {
      return NextResponse.json(
        { error: "Could not find Google Place ID" },
        { status: 404 },
      );
    }

    // Step 2: Get photo reference from Place Details
    const detailsUrl = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&fields=photos&key=${API_KEY}`;
    const detailsRes = await fetch(detailsUrl);
    const detailsData = await detailsRes.json();

    const photoReference = detailsData.result?.photos?.[0]?.photo_reference;

    if (!photoReference) {
      // Update place_id even if no photo found
      await supabase
        .from("shops")
        .update({ google_place_id: placeId })
        .eq("id", shopId);

      return NextResponse.json(
        { error: "No photos available for this place", placeId },
        { status: 404 },
      );
    }

    // Step 3: Generate photo URL
    const photoUrl = `https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${photoReference}&key=${API_KEY}`;

    // Step 4: Update shop in database
    const { error: updateError } = await supabase
      .from("shops")
      .update({
        google_place_id: placeId,
        google_photo_url: photoUrl,
      })
      .eq("id", shopId);

    if (updateError) {
      console.error("Failed to update shop:", updateError);
      return NextResponse.json(
        { error: "Failed to update shop" },
        { status: 500 },
      );
    }

    return NextResponse.json({
      success: true,
      placeId,
      photoUrl,
    });
  } catch (error) {
    console.error("Error in /api/shops/photo:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 },
    );
  }
}
