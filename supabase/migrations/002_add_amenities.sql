-- Add amenity columns to shops table
-- Run this in Supabase SQL Editor

ALTER TABLE shops ADD COLUMN IF NOT EXISTS smoking_area boolean DEFAULT false;
ALTER TABLE shops ADD COLUMN IF NOT EXISTS english_staff boolean DEFAULT false;
ALTER TABLE shops ADD COLUMN IF NOT EXISTS delivery boolean DEFAULT false;
ALTER TABLE shops ADD COLUMN IF NOT EXISTS google_place_id text;

-- Add index for google_place_id for faster duplicate checking
CREATE INDEX IF NOT EXISTS shops_google_place_id_idx ON shops(google_place_id);

-- Enable RLS on shop_images if not already enabled
ALTER TABLE shop_images ENABLE ROW LEVEL SECURITY;

-- Create policy for shop_images to be publicly readable
DROP POLICY IF EXISTS "shop_images are public" ON shop_images;
CREATE POLICY "shop_images are public" ON shop_images FOR SELECT USING (true);

-- Grant SELECT on shop_images to anon and authenticated roles
GRANT SELECT ON shop_images TO anon, authenticated;

-- Enable RLS on products if not already enabled
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policy for products to be publicly readable
DROP POLICY IF EXISTS "products are public" ON products;
CREATE POLICY "products are public" ON products FOR SELECT USING (true);
