import { createClient } from "@supabase/supabase-js";
import { readFileSync, existsSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

// Get current directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const projectRoot = join(__dirname, "..");

// Load env from project root
const envPath = join(projectRoot, ".env.local");
if (!existsSync(envPath)) {
  console.error(`ERROR: .env.local not found at ${envPath}`);
  process.exit(1);
}

const envText = readFileSync(envPath, "utf8");
const env = Object.fromEntries(
  envText
    .split("\n")
    .filter((l) => l.includes("=") && !l.startsWith("#"))
    .map((l) => [
      l.split("=")[0].trim(),
      l.split("=").slice(1).join("=").trim(),
    ]),
);

const SUPABASE_URL = env["NEXT_PUBLIC_SUPABASE_URL"];
const SUPABASE_KEY = env["SUPABASE_SERVICE_ROLE_KEY"];

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("ERROR: Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Sample shop data - realistic Thai cannabis dispensaries
const SAMPLE_SHOPS = [
  // Bangkok - Sukhumvit
  {
    name: "Green Leaf Bangkok",
    address: "123 Sukhumvit Soi 11, Khlong Toei, Bangkok 10110",
    city: "Bangkok",
    lat: 13.7421,
    lng: 100.5562,
    phone: "+66 2 123 4567",
    website: "https://greenleafbkk.com",
    price_range: 2,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "Canna Culture",
    address: "45 Sukhumvit Soi 22, Khlong Toei, Bangkok 10110",
    city: "Bangkok",
    lat: 13.7285,
    lng: 100.5689,
    phone: "+66 2 234 5678",
    price_range: 3,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  {
    name: "Bangkok Buds",
    address: "78 Sukhumvit Soi 33, Watthana, Bangkok 10110",
    city: "Bangkok",
    lat: 13.7356,
    lng: 100.5721,
    phone: "+66 2 345 6789",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: false,
    english_staff: true,
    delivery: true,
  },
  // Bangkok - Silom
  {
    name: "Silom Green House",
    address: "234 Silom Road, Bang Rak, Bangkok 10500",
    city: "Bangkok",
    lat: 13.7262,
    lng: 100.5276,
    phone: "+66 2 456 7890",
    price_range: 2,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "CBD Wellness Silom",
    address: "56 Soi Convent, Silom, Bang Rak, Bangkok 10500",
    city: "Bangkok",
    lat: 13.7241,
    lng: 100.5342,
    phone: "+66 2 567 8901",
    price_range: 3,
    is_verified: true,
    is_premium: false,
    smoking_area: false,
    english_staff: true,
    delivery: false,
  },
  // Bangkok - Khao San
  {
    name: "Khao San Cannabis Club",
    address: "123 Khao San Road, Phra Nakhon, Bangkok 10200",
    city: "Bangkok",
    lat: 13.7589,
    lng: 100.4974,
    phone: "+66 2 678 9012",
    price_range: 1,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  {
    name: "Backpacker Buds",
    address: "45 Rambuttri Road, Phra Nakhon, Bangkok 10200",
    city: "Bangkok",
    lat: 13.7612,
    lng: 100.4956,
    phone: "+66 2 789 0123",
    price_range: 1,
    is_verified: false,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  // Bangkok - Ratchada
  {
    name: "Ratchada 420",
    address: "789 Ratchadaphisek Road, Din Daeng, Bangkok 10400",
    city: "Bangkok",
    lat: 13.7698,
    lng: 100.5673,
    phone: "+66 2 890 1234",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: false,
    delivery: true,
  },
  // Chiang Mai
  {
    name: "Nimman Greens",
    address: "12 Nimmanhaemin Road, Su Thep, Chiang Mai 50200",
    city: "Chiang Mai",
    lat: 18.7985,
    lng: 98.9673,
    phone: "+66 53 123 456",
    website: "https://nimmangreens.com",
    price_range: 2,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "Old City Cannabis",
    address: "34 Ratchadamnoen Road, Si Phum, Chiang Mai 50200",
    city: "Chiang Mai",
    lat: 18.7878,
    lng: 98.9912,
    phone: "+66 53 234 567",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  {
    name: "Highland Herbs",
    address: "56 Huay Kaew Road, Su Thep, Chiang Mai 50200",
    city: "Chiang Mai",
    lat: 18.8045,
    lng: 98.9589,
    phone: "+66 53 345 678",
    price_range: 3,
    is_verified: true,
    is_premium: false,
    smoking_area: false,
    english_staff: true,
    delivery: true,
  },
  // Phuket
  {
    name: "Patong Paradise Cannabis",
    address: "123 Bangla Road, Patong, Phuket 83150",
    city: "Phuket",
    lat: 7.8961,
    lng: 98.296,
    phone: "+66 76 123 456",
    website: "https://patongparadise.com",
    price_range: 3,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "Kata Beach Buds",
    address: "45 Kata Road, Karon, Phuket 83100",
    city: "Phuket",
    lat: 7.8215,
    lng: 98.2978,
    phone: "+66 76 234 567",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  {
    name: "Phuket Town Dispensary",
    address: "78 Thalang Road, Talat Yai, Phuket 83000",
    city: "Phuket",
    lat: 7.8853,
    lng: 98.3879,
    phone: "+66 76 345 678",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: false,
    english_staff: true,
    delivery: true,
  },
  // Pattaya
  {
    name: "Walking Street Weed",
    address: "123 Walking Street, Bang Lamung, Pattaya 20150",
    city: "Pattaya",
    lat: 12.9271,
    lng: 100.8735,
    phone: "+66 38 123 456",
    price_range: 2,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "Jomtien Cannabis Co",
    address: "456 Jomtien Beach Road, Bang Lamung, Pattaya 20150",
    city: "Pattaya",
    lat: 12.8723,
    lng: 100.8801,
    phone: "+66 38 234 567",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  // Koh Samui
  {
    name: "Chaweng Green",
    address: "89 Chaweng Beach Road, Bo Phut, Koh Samui 84320",
    city: "Koh Samui",
    lat: 9.5345,
    lng: 100.0612,
    phone: "+66 77 123 456",
    price_range: 3,
    is_verified: true,
    is_premium: true,
    smoking_area: true,
    english_staff: true,
    delivery: true,
  },
  {
    name: "Lamai Leaf",
    address: "23 Lamai Beach Road, Maret, Koh Samui 84310",
    city: "Koh Samui",
    lat: 9.4756,
    lng: 100.0598,
    phone: "+66 77 234 567",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  // Koh Phangan
  {
    name: "Full Moon Buds",
    address: "Haad Rin Beach, Ko Pha-ngan 84280",
    city: "Koh Phangan",
    lat: 9.6789,
    lng: 100.0612,
    phone: "+66 77 345 678",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
  // Krabi
  {
    name: "Ao Nang Cannabis",
    address: "123 Ao Nang Beach Road, Ao Nang, Krabi 81000",
    city: "Krabi",
    lat: 8.0312,
    lng: 98.8234,
    phone: "+66 75 123 456",
    price_range: 2,
    is_verified: true,
    is_premium: false,
    smoking_area: true,
    english_staff: true,
    delivery: false,
  },
];

async function seedData() {
  console.log("\n========================================");
  console.log("  KUSHMAP Sample Data Seeder");
  console.log("========================================\n");
  console.log(`Supabase URL: ${SUPABASE_URL}`);
  console.log(`Shops to insert: ${SAMPLE_SHOPS.length}\n`);

  let inserted = 0;
  let skipped = 0;

  for (const shop of SAMPLE_SHOPS) {
    // Check if shop already exists
    const { data: existing } = await supabase
      .from("shops")
      .select("id")
      .eq("name", shop.name)
      .maybeSingle();

    if (existing) {
      console.log(`⏭ Skipped (exists): ${shop.name}`);
      skipped++;
      continue;
    }

    const { error } = await supabase.from("shops").insert(shop);

    if (error) {
      console.error(`✗ Error inserting ${shop.name}: ${error.message}`);
    } else {
      console.log(`✓ Inserted: ${shop.name} (${shop.city})`);
      inserted++;
    }
  }

  console.log("\n========================================");
  console.log(`✅ Complete!`);
  console.log(`   Inserted: ${inserted}`);
  console.log(`   Skipped: ${skipped}`);
  console.log("========================================\n");
}

seedData().catch((err) => {
  console.error(`FATAL: ${err.message}`);
  process.exit(1);
});
