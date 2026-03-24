"use client";

export type Area =
  | "all"
  | "sukhumvit"
  | "silom"
  | "khao_san"
  | "ratchada"
  | "thonglor"
  | "ari"
  | "chiang_mai"
  | "phuket"
  | "pattaya"
  | "koh_samui"
  | "koh_phangan"
  | "krabi"
  | "hua_hin";

const AREAS: { id: Area; label: string; lat?: number; lng?: number }[] = [
  { id: "all", label: "すべて" },
  // Bangkok
  { id: "sukhumvit", label: "Sukhumvit", lat: 13.744, lng: 100.557 },
  { id: "silom", label: "Silom", lat: 13.7274, lng: 100.5347 },
  { id: "khao_san", label: "Khao San", lat: 13.7589, lng: 100.4977 },
  { id: "ratchada", label: "Ratchada", lat: 13.77, lng: 100.568 },
  { id: "thonglor", label: "Thonglor", lat: 13.732, lng: 100.585 },
  { id: "ari", label: "Ari", lat: 13.779, lng: 100.545 },
  // Other cities
  { id: "chiang_mai", label: "Chiang Mai", lat: 18.7883, lng: 98.9853 },
  { id: "phuket", label: "Phuket", lat: 7.8804, lng: 98.3923 },
  { id: "pattaya", label: "Pattaya", lat: 12.9236, lng: 100.8825 },
  { id: "koh_samui", label: "Koh Samui", lat: 9.512, lng: 100.0136 },
  { id: "koh_phangan", label: "Koh Phangan", lat: 9.7379, lng: 100.0136 },
  { id: "krabi", label: "Krabi", lat: 8.0863, lng: 98.9063 },
  { id: "hua_hin", label: "Hua Hin", lat: 12.5684, lng: 99.9577 },
];

interface AreaFilterProps {
  active: Area;
  onChange: (area: Area, lat?: number, lng?: number) => void;
}

export default function AreaFilter({ active, onChange }: AreaFilterProps) {
  return (
    <div className="flex gap-1.5 overflow-x-auto scrollbar-hide pb-1 -mb-1">
      {AREAS.map((a) => (
        <button
          key={a.id}
          onClick={() => onChange(a.id, a.lat, a.lng)}
          className={`shrink-0 px-3 py-1.5 sm:py-1 rounded-full text-xs font-medium border transition-colors whitespace-nowrap touch-target ${
            active === a.id
              ? "bg-orange-500 text-white border-orange-500"
              : "bg-white text-gray-600 border-gray-300 hover:border-orange-400 hover:text-orange-500"
          }`}
        >
          {a.label}
        </button>
      ))}
    </div>
  );
}
