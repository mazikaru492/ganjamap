-- ============================================
-- KUSHMAP Complete Setup Script
-- ============================================
-- Run this entire script in Supabase SQL Editor
-- Supabase Dashboard → SQL Editor → New Query → Paste & Run
-- ============================================

-- =====================
-- 1. ENABLE EXTENSIONS
-- =====================
create extension if not exists postgis;

-- =====================
-- 2. CREATE TABLES
-- =====================

-- Shops
create table if not exists shops (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_th text,
  description text,
  address text not null,
  city text default 'Bangkok',
  lat float8 not null,
  lng float8 not null,
  location geography(point, 4326),
  phone text,
  website text,
  instagram text,
  google_place_id text,
  opening_hours jsonb,
  price_range int check (price_range between 1 and 3),
  is_verified bool default false,
  is_premium bool default false,
  is_hidden bool default false,
  smoking_area boolean default false,
  english_staff boolean default false,
  delivery boolean default false,
  card_payment boolean default false,
  wifi boolean default false,
  created_at timestamptz default now()
);

-- Shop images
create table if not exists shop_images (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid references shops(id) on delete cascade,
  url text not null,
  is_primary bool default false,
  created_at timestamptz default now()
);

-- Products (menu)
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid references shops(id) on delete cascade,
  name text not null,
  strain_type text check (strain_type in ('indica','sativa','hybrid','cbd')),
  category text check (category in ('flower','oil','edible','joint','cbd')),
  thc_percent float4,
  price_thb int,
  in_stock bool default true,
  created_at timestamptz default now()
);

-- Reviews
create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid references shops(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  rating int check (rating between 1 and 5),
  body text,
  is_flagged bool default false,
  created_at timestamptz default now()
);

-- Google reviews
create table if not exists google_reviews (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid references shops(id) on delete cascade,
  author_name text,
  rating int check (rating between 1 and 5),
  text_en text,
  text_ja text,
  text_th text,
  relative_time text,
  created_at timestamptz default now()
);

-- Bookmarks
create table if not exists bookmarks (
  user_id uuid references auth.users(id) on delete cascade,
  shop_id uuid references shops(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, shop_id)
);

-- Shop owners
create table if not exists shop_owners (
  shop_id uuid references shops(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  plan text default 'free' check (plan in ('free','premium')),
  plan_expires_at timestamptz,
  primary key (shop_id, user_id)
);

-- Admins
create table if not exists admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz default now()
);

-- =====================
-- 3. FUNCTIONS & TRIGGERS
-- =====================

-- Auto-update location from lat/lng
create or replace function update_shop_location()
returns trigger as $$
begin
  new.location = st_point(new.lng, new.lat)::geography;
  return new;
end;
$$ language plpgsql;

drop trigger if exists shop_location_trigger on shops;
create trigger shop_location_trigger
before insert or update on shops
for each row execute function update_shop_location();

-- Spatial index
create index if not exists shops_location_idx on shops using gist(location);

-- Nearby shops function
create or replace function nearby_shops(
  lat float, lng float, radius_km float default 5
)
returns setof shops as $$
begin
  return query
  select * from shops
  where st_dwithin(
    location,
    st_point(lng, lat)::geography,
    radius_km * 1000
  )
  order by location <-> st_point(lng, lat)::geography;
end;
$$ language plpgsql;

-- Admin helper function
create or replace function is_admin() returns boolean as $$
  select exists (select 1 from admins where user_id = auth.uid());
$$ language sql security definer;

-- =====================
-- 4. ROW LEVEL SECURITY
-- =====================

alter table shops enable row level security;
alter table shop_images enable row level security;
alter table products enable row level security;
alter table reviews enable row level security;
alter table bookmarks enable row level security;
alter table shop_owners enable row level security;
alter table admins enable row level security;
alter table google_reviews enable row level security;

-- Drop existing policies to avoid conflicts
drop policy if exists "shops are public" on shops;
drop policy if exists "admins can update shops" on shops;
drop policy if exists "admins can delete shops" on shops;
drop policy if exists "shop_images are public" on shop_images;
drop policy if exists "products are public" on products;
drop policy if exists "reviews are public for read" on reviews;
drop policy if exists "users manage own reviews" on reviews;
drop policy if exists "admins can read all reviews" on reviews;
drop policy if exists "admins can delete reviews" on reviews;
drop policy if exists "admins can update reviews" on reviews;
drop policy if exists "users manage own bookmarks" on bookmarks;
drop policy if exists "admins can read all bookmarks" on bookmarks;
drop policy if exists "admins can read admins" on admins;
drop policy if exists "admins can read all shop_owners" on shop_owners;
drop policy if exists "google_reviews are public" on google_reviews;

-- Shops policies
create policy "shops are public" on shops for select
  using (is_hidden is not true or is_admin());
create policy "admins can update shops" on shops for update using (is_admin());
create policy "admins can delete shops" on shops for delete using (is_admin());

-- Shop images policy (PUBLIC READ - IMPORTANT!)
create policy "shop_images are public" on shop_images for select using (true);

-- Products policy
create policy "products are public" on products for select using (true);

-- Google reviews policy
create policy "google_reviews are public" on google_reviews for select using (true);

-- Reviews policies
create policy "reviews are public for read" on reviews for select using (true);
create policy "users manage own reviews" on reviews for all using (auth.uid() = user_id);
create policy "admins can read all reviews" on reviews for select using (is_admin());
create policy "admins can delete reviews" on reviews for delete using (is_admin());
create policy "admins can update reviews" on reviews for update using (is_admin());

-- Bookmarks policies
create policy "users manage own bookmarks" on bookmarks for all using (auth.uid() = user_id);
create policy "admins can read all bookmarks" on bookmarks for select using (is_admin());

-- Admins policy
create policy "admins can read admins" on admins for select using (is_admin());

-- Shop owners policy
create policy "admins can read all shop_owners" on shop_owners for select using (is_admin());

-- =====================
-- 5. GRANT PERMISSIONS
-- =====================
grant select on shops to anon, authenticated;
grant select on shop_images to anon, authenticated;
grant select on products to anon, authenticated;
grant select on google_reviews to anon, authenticated;
grant select on reviews to anon, authenticated;
grant insert, update, delete on reviews to authenticated;
grant select, insert, delete on bookmarks to authenticated;

-- =====================
-- 6. SEED DATA
-- =====================

-- Bangkok Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
-- Sukhumvit Area
('Cloud Nine Cannabis', 'คลาวด์ไนน์', 'Premium cannabis lounge with rooftop terrace', '123 Sukhumvit Soi 11, Khlong Toei', 'Bangkok', 13.7445, 100.5565, '+66-2-123-4567', 'https://cloudnine.example.com', '{"mon":"10:00-00:00","tue":"10:00-00:00","wed":"10:00-00:00","thu":"10:00-00:00","fri":"10:00-02:00","sat":"10:00-02:00","sun":"12:00-00:00"}', 3, true, true, true, true, true),
('Green Leaf Dispensary', 'กรีนลีฟ', 'Friendly neighborhood shop with quality products', '45 Sukhumvit Soi 22, Khlong Toei', 'Bangkok', 13.7265, 100.5680, '+66-2-234-5678', NULL, '{"mon":"09:00-22:00","tue":"09:00-22:00","wed":"09:00-22:00","thu":"09:00-22:00","fri":"09:00-23:00","sat":"09:00-23:00","sun":"10:00-21:00"}', 2, true, false, true, true, false),
('Bangkok Buds', 'บางกอกบัดส์', 'Wide selection of strains at competitive prices', '78 Sukhumvit Soi 4, Khlong Toei', 'Bangkok', 13.7385, 100.5535, '+66-2-345-6789', 'https://bangkokbuds.example.com', '{"mon":"10:00-23:00","tue":"10:00-23:00","wed":"10:00-23:00","thu":"10:00-23:00","fri":"10:00-01:00","sat":"10:00-01:00","sun":"11:00-22:00"}', 2, true, false, false, true, true),
('Nana Green House', 'นานากรีนเฮาส์', 'Cozy spot near Nana Plaza', '156 Sukhumvit Soi 4, Khlong Toei', 'Bangkok', 13.7395, 100.5540, '+66-2-456-7890', NULL, '{"mon":"11:00-02:00","tue":"11:00-02:00","wed":"11:00-02:00","thu":"11:00-02:00","fri":"11:00-03:00","sat":"11:00-03:00","sun":"12:00-02:00"}', 2, false, false, true, true, false),
('Asok Cannabis Club', 'อโศกกัญชาคลับ', 'Members-only premium experience', '99 Asok Montri Rd, Khlong Toei', 'Bangkok', 13.7365, 100.5610, '+66-2-567-8901', 'https://asokcc.example.com', '{"mon":"12:00-00:00","tue":"12:00-00:00","wed":"12:00-00:00","thu":"12:00-00:00","fri":"12:00-02:00","sat":"12:00-02:00","sun":"14:00-22:00"}', 3, true, true, true, true, false),

-- Silom Area
('Silom Smoke Shop', 'สีลมสโมคช็อป', 'Central location, great for tourists', '234 Silom Rd, Bang Rak', 'Bangkok', 13.7280, 100.5350, '+66-2-678-9012', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, false, true, true),
('Patpong Green', 'พัฒน์พงษ์กรีน', 'Night market favorite', '67 Patpong Soi 1, Bang Rak', 'Bangkok', 13.7260, 100.5330, '+66-2-789-0123', NULL, '{"mon":"16:00-02:00","tue":"16:00-02:00","wed":"16:00-02:00","thu":"16:00-02:00","fri":"16:00-04:00","sat":"16:00-04:00","sun":"16:00-00:00"}', 1, false, false, true, false, false),

-- Khao San Area
('Khao San Kush', 'ข้าวสารกัช', 'Backpacker paradise with chill vibes', '89 Khao San Rd, Phra Nakhon', 'Bangkok', 13.7590, 100.4975, '+66-2-890-1234', 'https://khaosankush.example.com', '{"mon":"10:00-02:00","tue":"10:00-02:00","wed":"10:00-02:00","thu":"10:00-02:00","fri":"10:00-04:00","sat":"10:00-04:00","sun":"10:00-02:00"}', 1, true, false, true, true, false),
('Rambuttri Relaxation', 'รามบุตรี', 'Quiet escape from the busy street', '23 Rambuttri Rd, Phra Nakhon', 'Bangkok', 13.7615, 100.4960, '+66-2-901-2345', NULL, '{"mon":"11:00-00:00","tue":"11:00-00:00","wed":"11:00-00:00","thu":"11:00-00:00","fri":"11:00-01:00","sat":"11:00-01:00","sun":"12:00-23:00"}', 2, false, false, true, true, false),

-- Ratchada Area
('Ratchada Cannabis Co.', 'รัชดากัญชา', 'Modern dispensary near MRT', '456 Ratchadaphisek Rd, Din Daeng', 'Bangkok', 13.7700, 100.5680, '+66-2-012-3456', 'https://ratchadacannabis.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, true),

-- Ekkamai/Thonglor
('Thonglor Terrace', 'ทองหล่อเทอเรซ', 'Upscale lounge experience', '88 Thonglor Soi 10, Watthana', 'Bangkok', 13.7320, 100.5850, '+66-2-123-4567', 'https://thonglorterrace.example.com', '{"mon":"14:00-00:00","tue":"14:00-00:00","wed":"14:00-00:00","thu":"14:00-00:00","fri":"14:00-02:00","sat":"14:00-02:00","sun":"14:00-22:00"}', 3, true, true, true, true, false),
('Ekkamai Express', 'เอกมัยเอ็กซ์เพรส', 'Quick service, quality products', '55 Sukhumvit Soi 63, Khlong Tan Nuea', 'Bangkok', 13.7190, 100.5870, '+66-2-234-5678', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"10:00-22:00","sun":"10:00-20:00"}', 2, false, false, false, true, true),

-- Ari
('Ari Wellness', 'อารีเวลเนส', 'Health-focused cannabis products', '34 Phahonyothin Soi 7, Phaya Thai', 'Bangkok', 13.7790, 100.5450, '+66-2-345-6789', 'https://ariwellness.example.com', '{"mon":"10:00-20:00","tue":"10:00-20:00","wed":"10:00-20:00","thu":"10:00-20:00","fri":"10:00-21:00","sat":"10:00-21:00","sun":"11:00-19:00"}', 2, true, false, false, true, true)
ON CONFLICT DO NOTHING;

-- Chiang Mai Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Nimman Greens', 'นิมมานกรีนส์', 'Hip dispensary in the trendy Nimman area', '12 Nimmanhaemin Rd, Suthep', 'Chiang Mai', 18.8010, 98.9680, '+66-53-123-456', 'https://nimmangreens.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, true, true, true, true),
('Old City Cannabis', 'กัญชาเมืองเก่า', 'Traditional setting, modern products', '56 Moon Muang Rd, Si Phum', 'Chiang Mai', 18.7895, 98.9870, '+66-53-234-567', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, true, false, true, true, false),
('Chang Phueak Chill', 'ช้างเผือกชิล', 'Local favorite near the north gate', '78 Chang Phueak Rd, Chang Phueak', 'Chiang Mai', 18.8020, 98.9890, '+66-53-345-678', NULL, '{"mon":"11:00-23:00","tue":"11:00-23:00","wed":"11:00-23:00","thu":"11:00-23:00","fri":"11:00-00:00","sat":"11:00-00:00","sun":"12:00-22:00"}', 2, false, false, true, true, false),
('Maya Cannabis', 'มายากัญชา', 'Located near Maya Mall', '99 Huay Kaew Rd, Suthep', 'Chiang Mai', 18.8050, 98.9670, '+66-53-456-789', 'https://mayacannabis.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 3, true, false, true, true, true)
ON CONFLICT DO NOTHING;

-- Phuket Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Patong Paradise', 'ป่าตองพาราไดซ์', 'Beach town favorite', '234 Bangla Rd, Patong', 'Phuket', 7.8960, 98.2970, '+66-76-123-456', 'https://patongparadise.example.com', '{"mon":"10:00-02:00","tue":"10:00-02:00","wed":"10:00-02:00","thu":"10:00-02:00","fri":"10:00-04:00","sat":"10:00-04:00","sun":"12:00-00:00"}', 2, true, true, true, true, true),
('Kata Beach Buds', 'กะตะบีชบัดส์', 'Relaxed beach vibes', '45 Kata Rd, Karon', 'Phuket', 7.8200, 98.2990, '+66-76-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false),
('Phuket Town Cannabis', 'ภูเก็ตทาวน์กัญชา', 'Authentic local experience', '67 Thalang Rd, Talat Yai', 'Phuket', 7.8870, 98.3880, '+66-76-345-678', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, false, false, false, true, true),
('Rawai Relax', 'ราไวย์รีแลกซ์', 'Quiet spot in the south', '123 Viset Rd, Rawai', 'Phuket', 7.7820, 98.3290, '+66-76-456-789', 'https://rawairelax.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false)
ON CONFLICT DO NOTHING;

-- Pattaya Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Walking Street Weed', 'วอล์คกิ้งสตรีทวีด', 'Party central location', '156 Walking St, Bang Lamung', 'Pattaya', 12.9270, 100.8770, '+66-38-123-456', 'https://walkingstreetweed.example.com', '{"mon":"16:00-04:00","tue":"16:00-04:00","wed":"16:00-04:00","thu":"16:00-04:00","fri":"16:00-06:00","sat":"16:00-06:00","sun":"16:00-02:00"}', 2, true, false, true, true, false),
('Jomtien Joint', 'จอมเทียนจอยท์', 'Beachside chill spot', '78 Jomtien Beach Rd, Bang Lamung', 'Pattaya', 12.8720, 100.8780, '+66-38-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-00:00","sat":"10:00-00:00","sun":"11:00-21:00"}', 1, true, false, true, true, true),
('Pattaya Premium', 'พัทยาพรีเมี่ยม', 'High-end experience', '234 Beach Rd, Bang Lamung', 'Pattaya', 12.9350, 100.8800, '+66-38-345-678', 'https://pattayapremium.example.com', '{"mon":"12:00-00:00","tue":"12:00-00:00","wed":"12:00-00:00","thu":"12:00-00:00","fri":"12:00-02:00","sat":"12:00-02:00","sun":"14:00-22:00"}', 3, true, true, true, true, false)
ON CONFLICT DO NOTHING;

-- Koh Samui Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Chaweng Cannabis', 'เฉวงกัญชา', 'Beach Road favorite', '45 Chaweng Beach Rd, Bo Phut', 'Koh Samui', 9.5360, 100.0600, '+66-77-123-456', 'https://chawengcannabis.example.com', '{"mon":"10:00-00:00","tue":"10:00-00:00","wed":"10:00-00:00","thu":"10:00-00:00","fri":"10:00-02:00","sat":"10:00-02:00","sun":"11:00-23:00"}', 2, true, true, true, true, true),
('Lamai Leaf', 'ละไมลีฟ', 'Laid-back island vibes', '67 Lamai Beach Rd, Maret', 'Koh Samui', 9.4770, 100.0600, '+66-77-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, false, false, true, true, false),
('Fisherman Village Green', 'หมู่บ้านชาวประมงกรีน', 'Charming Bophut location', '23 Bophut Beach Rd, Bo Phut', 'Koh Samui', 9.5300, 100.0150, '+66-77-345-678', NULL, '{"mon":"11:00-22:00","tue":"11:00-22:00","wed":"11:00-22:00","thu":"11:00-22:00","fri":"11:00-23:00","sat":"11:00-23:00","sun":"12:00-21:00"}', 2, true, false, false, true, false)
ON CONFLICT DO NOTHING;

-- Koh Phangan Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Haad Rin High', 'หาดริ้นไฮ', 'Full moon party central', '89 Haad Rin Beach, Ko Pha-ngan', 'Koh Phangan', 9.6780, 100.0650, '+66-77-456-789', 'https://haadrinhigh.example.com', '{"mon":"14:00-04:00","tue":"14:00-04:00","wed":"14:00-04:00","thu":"14:00-04:00","fri":"14:00-06:00","sat":"14:00-06:00","sun":"14:00-02:00"}', 2, true, false, true, true, false),
('Thong Sala Smoke', 'ท่องศาลาสโมค', 'Main town convenience', '34 Thong Sala Pier Rd, Ko Pha-ngan', 'Koh Phangan', 9.7380, 99.9980, '+66-77-567-890', NULL, '{"mon":"09:00-22:00","tue":"09:00-22:00","wed":"09:00-22:00","thu":"09:00-22:00","fri":"09:00-23:00","sat":"09:00-23:00","sun":"10:00-21:00"}', 1, false, false, true, true, true)
ON CONFLICT DO NOTHING;

-- Koh Tao Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Sairee Smoke', 'ทรายรีสโมค', 'Diver paradise hangout', '56 Sairee Beach Rd, Ko Tao', 'Koh Tao', 10.1050, 99.8280, '+66-77-678-901', 'https://saireesmoke.example.com', '{"mon":"10:00-00:00","tue":"10:00-00:00","wed":"10:00-00:00","thu":"10:00-00:00","fri":"10:00-02:00","sat":"10:00-02:00","sun":"11:00-23:00"}', 2, true, false, true, true, false),
('Mae Haad Mellow', 'แม่หาดเมลโลว', 'Near the ferry pier', '12 Mae Haad Pier Rd, Ko Tao', 'Koh Tao', 10.0850, 99.8320, '+66-77-789-012', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, false, false, false, true, true)
ON CONFLICT DO NOTHING;

-- Krabi/Ao Nang Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Ao Nang Green', 'อ่าวนางกรีน', 'Beach town convenience', '78 Ao Nang Beach Rd, Ao Nang', 'Krabi', 8.0330, 98.8180, '+66-75-123-456', 'https://aonanggreen.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false),
('Railay Relax', 'ไร่เลย์รีแลกซ์', 'Stunning cliff views', '34 Railay Beach, Ao Nang', 'Krabi', 8.0080, 98.8370, '+66-75-234-567', NULL, '{"mon":"10:00-20:00","tue":"10:00-20:00","wed":"10:00-20:00","thu":"10:00-20:00","fri":"10:00-21:00","sat":"10:00-21:00","sun":"11:00-19:00"}', 2, true, true, true, true, false)
ON CONFLICT DO NOTHING;

-- Hua Hin Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Hua Hin High', 'หัวหินไฮ', 'Royal resort town cannabis', '89 Phetkasem Rd, Hua Hin', 'Hua Hin', 12.5700, 99.9580, '+66-32-123-456', 'https://huahinhigh.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, true),
('Night Market Nug', 'ไนท์มาร์เก็ตนัก', 'Near the famous night market', '45 Dechanuchit Rd, Hua Hin', 'Hua Hin', 12.5730, 99.9520, '+66-32-234-567', NULL, '{"mon":"16:00-00:00","tue":"16:00-00:00","wed":"16:00-00:00","thu":"16:00-00:00","fri":"16:00-01:00","sat":"16:00-01:00","sun":"16:00-23:00"}', 1, false, false, true, false, false)
ON CONFLICT DO NOTHING;

-- =====================
-- SETUP COMPLETE!
-- =====================
-- Your database now has:
-- - All required tables
-- - RLS policies for security
-- - 35 sample shops across Thailand
-- =====================
