-- KUSHMAP Seed Data
-- Run this in Supabase SQL Editor to populate sample shops

-- Clear existing data (optional - comment out if you want to keep existing data)
-- DELETE FROM shop_images;
-- DELETE FROM shops;

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
('Ari Wellness', 'อารีเวลเนส', 'Health-focused cannabis products', '34 Phahonyothin Soi 7, Phaya Thai', 'Bangkok', 13.7790, 100.5450, '+66-2-345-6789', 'https://ariwellness.example.com', '{"mon":"10:00-20:00","tue":"10:00-20:00","wed":"10:00-20:00","thu":"10:00-20:00","fri":"10:00-21:00","sat":"10:00-21:00","sun":"11:00-19:00"}', 2, true, false, false, true, true);

-- Chiang Mai Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Nimman Greens', 'นิมมานกรีนส์', 'Hip dispensary in the trendy Nimman area', '12 Nimmanhaemin Rd, Suthep', 'Chiang Mai', 18.8010, 98.9680, '+66-53-123-456', 'https://nimmangreens.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, true, true, true, true),
('Old City Cannabis', 'กัญชาเมืองเก่า', 'Traditional setting, modern products', '56 Moon Muang Rd, Si Phum', 'Chiang Mai', 18.7895, 98.9870, '+66-53-234-567', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, true, false, true, true, false),
('Chang Phueak Chill', 'ช้างเผือกชิล', 'Local favorite near the north gate', '78 Chang Phueak Rd, Chang Phueak', 'Chiang Mai', 18.8020, 98.9890, '+66-53-345-678', NULL, '{"mon":"11:00-23:00","tue":"11:00-23:00","wed":"11:00-23:00","thu":"11:00-23:00","fri":"11:00-00:00","sat":"11:00-00:00","sun":"12:00-22:00"}', 2, false, false, true, true, false),
('Maya Cannabis', 'มายากัญชา', 'Located near Maya Mall', '99 Huay Kaew Rd, Suthep', 'Chiang Mai', 18.8050, 98.9670, '+66-53-456-789', 'https://mayacannabis.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 3, true, false, true, true, true);

-- Phuket Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Patong Paradise', 'ป่าตองพาราไดซ์', 'Beach town favorite', '234 Bangla Rd, Patong', 'Phuket', 7.8960, 98.2970, '+66-76-123-456', 'https://patongparadise.example.com', '{"mon":"10:00-02:00","tue":"10:00-02:00","wed":"10:00-02:00","thu":"10:00-02:00","fri":"10:00-04:00","sat":"10:00-04:00","sun":"12:00-00:00"}', 2, true, true, true, true, true),
('Kata Beach Buds', 'กะตะบีชบัดส์', 'Relaxed beach vibes', '45 Kata Rd, Karon', 'Phuket', 7.8200, 98.2990, '+66-76-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false),
('Phuket Town Cannabis', 'ภูเก็ตทาวน์กัญชา', 'Authentic local experience', '67 Thalang Rd, Talat Yai', 'Phuket', 7.8870, 98.3880, '+66-76-345-678', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, false, false, false, true, true),
('Rawai Relax', 'ราไวย์รีแลกซ์', 'Quiet spot in the south', '123 Viset Rd, Rawai', 'Phuket', 7.7820, 98.3290, '+66-76-456-789', 'https://rawairelax.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false);

-- Pattaya Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Walking Street Weed', 'วอล์คกิ้งสตรีทวีด', 'Party central location', '156 Walking St, Bang Lamung', 'Pattaya', 12.9270, 100.8770, '+66-38-123-456', 'https://walkingstreetweed.example.com', '{"mon":"16:00-04:00","tue":"16:00-04:00","wed":"16:00-04:00","thu":"16:00-04:00","fri":"16:00-06:00","sat":"16:00-06:00","sun":"16:00-02:00"}', 2, true, false, true, true, false),
('Jomtien Joint', 'จอมเทียนจอยท์', 'Beachside chill spot', '78 Jomtien Beach Rd, Bang Lamung', 'Pattaya', 12.8720, 100.8780, '+66-38-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-00:00","sat":"10:00-00:00","sun":"11:00-21:00"}', 1, true, false, true, true, true),
('Pattaya Premium', 'พัทยาพรีเมี่ยม', 'High-end experience', '234 Beach Rd, Bang Lamung', 'Pattaya', 12.9350, 100.8800, '+66-38-345-678', 'https://pattayapremium.example.com', '{"mon":"12:00-00:00","tue":"12:00-00:00","wed":"12:00-00:00","thu":"12:00-00:00","fri":"12:00-02:00","sat":"12:00-02:00","sun":"14:00-22:00"}', 3, true, true, true, true, false);

-- Koh Samui Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Chaweng Cannabis', 'เฉวงกัญชา', 'Beach Road favorite', '45 Chaweng Beach Rd, Bo Phut', 'Koh Samui', 9.5360, 100.0600, '+66-77-123-456', 'https://chawengcannabis.example.com', '{"mon":"10:00-00:00","tue":"10:00-00:00","wed":"10:00-00:00","thu":"10:00-00:00","fri":"10:00-02:00","sat":"10:00-02:00","sun":"11:00-23:00"}', 2, true, true, true, true, true),
('Lamai Leaf', 'ละไมลีฟ', 'Laid-back island vibes', '67 Lamai Beach Rd, Maret', 'Koh Samui', 9.4770, 100.0600, '+66-77-234-567', NULL, '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, false, false, true, true, false),
('Fisherman Village Green', 'หมู่บ้านชาวประมงกรีน', 'Charming Bophut location', '23 Bophut Beach Rd, Bo Phut', 'Koh Samui', 9.5300, 100.0150, '+66-77-345-678', NULL, '{"mon":"11:00-22:00","tue":"11:00-22:00","wed":"11:00-22:00","thu":"11:00-22:00","fri":"11:00-23:00","sat":"11:00-23:00","sun":"12:00-21:00"}', 2, true, false, false, true, false);

-- Koh Phangan Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Haad Rin High', 'หาดริ้นไฮ', 'Full moon party central', '89 Haad Rin Beach, Ko Pha-ngan', 'Koh Phangan', 9.6780, 100.0650, '+66-77-456-789', 'https://haadrinhigh.example.com', '{"mon":"14:00-04:00","tue":"14:00-04:00","wed":"14:00-04:00","thu":"14:00-04:00","fri":"14:00-06:00","sat":"14:00-06:00","sun":"14:00-02:00"}', 2, true, false, true, true, false),
('Thong Sala Smoke', 'ท่องศาลาสโมค', 'Main town convenience', '34 Thong Sala Pier Rd, Ko Pha-ngan', 'Koh Phangan', 9.7380, 99.9980, '+66-77-567-890', NULL, '{"mon":"09:00-22:00","tue":"09:00-22:00","wed":"09:00-22:00","thu":"09:00-22:00","fri":"09:00-23:00","sat":"09:00-23:00","sun":"10:00-21:00"}', 1, false, false, true, true, true);

-- Koh Tao Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Sairee Smoke', 'ทรายรีสโมค', 'Diver paradise hangout', '56 Sairee Beach Rd, Ko Tao', 'Koh Tao', 10.1050, 99.8280, '+66-77-678-901', 'https://saireesmoke.example.com', '{"mon":"10:00-00:00","tue":"10:00-00:00","wed":"10:00-00:00","thu":"10:00-00:00","fri":"10:00-02:00","sat":"10:00-02:00","sun":"11:00-23:00"}', 2, true, false, true, true, false),
('Mae Haad Mellow', 'แม่หาดเมลโลว', 'Near the ferry pier', '12 Mae Haad Pier Rd, Ko Tao', 'Koh Tao', 10.0850, 99.8320, '+66-77-789-012', NULL, '{"mon":"09:00-21:00","tue":"09:00-21:00","wed":"09:00-21:00","thu":"09:00-21:00","fri":"09:00-22:00","sat":"09:00-22:00","sun":"10:00-20:00"}', 1, false, false, false, true, true);

-- Krabi/Ao Nang Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Ao Nang Green', 'อ่าวนางกรีน', 'Beach town convenience', '78 Ao Nang Beach Rd, Ao Nang', 'Krabi', 8.0330, 98.8180, '+66-75-123-456', 'https://aonanggreen.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, false),
('Railay Relax', 'ไร่เลย์รีแลกซ์', 'Stunning cliff views', '34 Railay Beach, Ao Nang', 'Krabi', 8.0080, 98.8370, '+66-75-234-567', NULL, '{"mon":"10:00-20:00","tue":"10:00-20:00","wed":"10:00-20:00","thu":"10:00-20:00","fri":"10:00-21:00","sat":"10:00-21:00","sun":"11:00-19:00"}', 2, true, true, true, true, false);

-- Hua Hin Shops
INSERT INTO shops (name, name_th, description, address, city, lat, lng, phone, website, opening_hours, price_range, is_verified, is_premium, smoking_area, english_staff, delivery) VALUES
('Hua Hin High', 'หัวหินไฮ', 'Royal resort town cannabis', '89 Phetkasem Rd, Hua Hin', 'Hua Hin', 12.5700, 99.9580, '+66-32-123-456', 'https://huahinhigh.example.com', '{"mon":"10:00-22:00","tue":"10:00-22:00","wed":"10:00-22:00","thu":"10:00-22:00","fri":"10:00-23:00","sat":"10:00-23:00","sun":"11:00-21:00"}', 2, true, false, true, true, true),
('Night Market Nug', 'ไนท์มาร์เก็ตนัก', 'Near the famous night market', '45 Dechanuchit Rd, Hua Hin', 'Hua Hin', 12.5730, 99.9520, '+66-32-234-567', NULL, '{"mon":"16:00-00:00","tue":"16:00-00:00","wed":"16:00-00:00","thu":"16:00-00:00","fri":"16:00-01:00","sat":"16:00-01:00","sun":"16:00-23:00"}', 1, false, false, true, false, false);

-- Add sample shop images (using placeholder URLs)
INSERT INTO shop_images (shop_id, url, is_primary)
SELECT id, 'https://images.unsplash.com/photo-1616690002158-d36ba4a84946?w=400', true FROM shops WHERE name = 'Cloud Nine Cannabis'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1591088741626-03f8f8b22f9e?w=400', false FROM shops WHERE name = 'Cloud Nine Cannabis'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1603909223429-69bb7101f420?w=400', true FROM shops WHERE name = 'Green Leaf Dispensary'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1585063560120-2c2f9fd87703?w=400', true FROM shops WHERE name = 'Bangkok Buds'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1584392335819-79c7a8a7e0ac?w=400', true FROM shops WHERE name = 'Nimman Greens'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1560705217-ad60ad51de98?w=400', true FROM shops WHERE name = 'Patong Paradise'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?w=400', true FROM shops WHERE name = 'Chaweng Cannabis'
UNION ALL
SELECT id, 'https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=400', true FROM shops WHERE name = 'Ao Nang Green';
