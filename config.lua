C = {}

C.Version = 1.0
C.Locale = 'tr'

C.MinimumBet = 25 -- En az bahis miktarı
C.WinPoint = 3 -- Oyun kaç turda bitsin?
C.InventoryKey = 289 -- Envanteri açma butonunuzu giriniz [NORMAL HALİ: 289 == F2]

-- Zar atma oyununun ayarları
C.DiceSettings = {
    ["PedHash"] = "csb_prologuedriver", -- Pedin görünümü
    ["Scenario"] = "WORLD_HUMAN_SMOKING", -- Animasyon [Scenario] olması gerekiyor.

    ["Coords"] = {
        [1] = {
            ["NPC"] = { x = 34.99248, y = -943.508, z = 28.390, h = 246.0552 },
            ["Player"] = { x = 35.97634, y = -943.738, z = 29.392, h = 74.77261 },
            ["Camera"] = { 35.59044, -946.0566, 30.06541, -5.90551, 2.187795, 6.850356 },
        },
        [2] = {
            ["NPC"] = { x = 253.3681, y = -306.139, z = 48.645, h = 337.3100 },
            ["Player"] = { x = 253.8994, y = -304.742, z = 49.645, h = 157.5111 },
            ["Camera"] = { 256.35, -305.14, 50.33, -7.24, 2.1344, 98.580 }
        },
        [3] = {
            ["NPC"] = { x = 238.8298, y = 113.4390, z = 101.63, h = 345.2521 },
            ["Player"] = { x = 239.3583, y = 114.6913, z = 102.62, h = 161.2037 },
            ["Camera"] = { 236.76, 116.08, 103.53, -12.59, 1.707, -137.24 }
        },
        [4] = {
            ["NPC"] = { x = 227.6864, y = -755.041, z = 33.645, h = 337.7218 },
            ["Player"] = { x = 228.2174, y = -753.503, z = 34.640, h = 158.9662 },
            ["Camera"] = { 225.7417, -752.21, 35.60, -16.22, -1.707, -142.91 }
        }
    },
}
