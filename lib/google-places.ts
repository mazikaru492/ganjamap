/**
 * Google Places Photo URL generator
 *
 * Usage:
 * 1. If shop has google_photo_url (already stored), use it directly
 * 2. Otherwise, call Places API to get photo_reference and generate URL
 */

const API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY;

/**
 * Generate Google Places Photo URL from photo_reference
 */
export function getPlacesPhotoUrl(
  photoReference: string,
  maxWidth = 400,
): string {
  return `https://maps.googleapis.com/maps/api/place/photo?maxwidth=${maxWidth}&photo_reference=${photoReference}&key=${API_KEY}`;
}

/**
 * Search for a place by name and location, returns place_id
 */
export async function findPlaceId(
  name: string,
  lat: number,
  lng: number,
): Promise<string | null> {
  if (!API_KEY) return null;

  try {
    const query = encodeURIComponent(name);
    const url = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${query}&inputtype=textquery&locationbias=circle:500@${lat},${lng}&fields=place_id&key=${API_KEY}`;
    const response = await fetch(url);
    const data = await response.json();

    if (data.candidates?.[0]?.place_id) {
      return data.candidates[0].place_id;
    }
  } catch (error) {
    console.error("Failed to find place ID:", error);
  }

  return null;
}

/**
 * Fetch place details including photo reference from Google Places API
 * Returns photo URL if available
 */
export async function fetchPlacePhoto(placeId: string): Promise<string | null> {
  if (!API_KEY) return null;

  try {
    const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&fields=photos&key=${API_KEY}`;
    const response = await fetch(url);
    const data = await response.json();

    if (data.result?.photos?.[0]?.photo_reference) {
      return getPlacesPhotoUrl(data.result.photos[0].photo_reference);
    }
  } catch (error) {
    console.error("Failed to fetch place photo:", error);
  }

  return null;
}

/**
 * Get photo URL for a shop by searching Google Places
 * Combines findPlaceId and fetchPlacePhoto
 */
export async function getShopPhotoUrl(
  name: string,
  lat: number,
  lng: number,
): Promise<{ placeId: string | null; photoUrl: string | null }> {
  const placeId = await findPlaceId(name, lat, lng);
  if (!placeId) {
    return { placeId: null, photoUrl: null };
  }

  const photoUrl = await fetchPlacePhoto(placeId);
  return { placeId, photoUrl };
}
