import Testing
@testable import PVSystems

/// `libretroDatabaseID` is `platforms.id` in the libretrodb SQLite build that
/// PVLookup reads. These pin the Neo Geo ids that were wrong in 1.0.0, give
/// Jaguar CD the platform PVLookup's database appends for it, and check every
/// mapped id against a copy of that table.
@Suite("libretrodb platform ids")
struct SystemIdentifierLibretroDBTests {
    // MARK: - The Neo Geo ids that were wrong in 1.0.0

    @Test("Neo Geo CD is platform 1, in both directions")
    func neoGeoCD() {
        #expect(SystemIdentifier.NeoGeoCD.libretroDatabaseID == 1)
        #expect(SystemIdentifier.fromLibretroDatabaseID(1) == .NeoGeoCD)
        // 1.0.0 used 136, which is not in the platforms table.
        #expect(SystemIdentifier.fromLibretroDatabaseID(136) == nil)
    }

    @Test("Cartridge Neo Geo has no libretrodb platform")
    func neoGeoCartridge() {
        #expect(SystemIdentifier.NeoGeo.libretroDatabaseID == Self.unmapped)
    }

    // MARK: - Jaguar CD

    // 1.0.0 sent Jaguar CD to 29, the cartridge platform, which has no discs.
    @Test("Jaguar CD is platform 120, in both directions, apart from Jaguar")
    func jaguarCDPlatform() {
        #expect(SystemIdentifier.AtariJaguarCD.libretroDatabaseID == 120)
        #expect(SystemIdentifier.fromLibretroDatabaseID(120) == .AtariJaguarCD)
        #expect(SystemIdentifier.AtariJaguar.libretroDatabaseID == 29)
        #expect(SystemIdentifier.fromLibretroDatabaseID(29) == .AtariJaguar)
    }

    // libretro-database's rdb name, and the thumbnail folder requested in
    // libretro-thumbnails/libretro-thumbnails#141.
    @Test("Jaguar CD uses its own libretro folder name")
    func jaguarCDName() {
        #expect(SystemIdentifier.AtariJaguarCD.libretroDatabaseName == "Atari - Jaguar CD")
        #expect(SystemIdentifier.AtariJaguarCD.libretroCheatSystemName == "Atari - Jaguar CD")
    }

    @Test("An unmapped id is not a system")
    func unmappedIDIsNotASystem() {
        #expect(SystemIdentifier.fromLibretroDatabaseID(Self.unmapped) == nil)
    }

    // MARK: - Disc systems

    @Test("Disc systems keep their platforms", arguments: [
        (SystemIdentifier.SegaCD, 2),
        (.PSX, 6),
        (.PCECD, 12),
        (.PCFX, 20),
        (.Saturn, 47),
        (._3DO, 73),
        (.Dreamcast, 99)
    ])
    func discSystem(_ system: SystemIdentifier, _ platformID: Int) {
        #expect(system.libretroDatabaseID == platformID)
        #expect(SystemIdentifier.fromLibretroDatabaseID(platformID) == system)
    }

    // MARK: - Every system, against the platforms table

    @Test("Every mapped id is a platform in libretrodb", arguments: SystemIdentifier.allCases)
    func mappedIDExists(_ system: SystemIdentifier) {
        let platformID = system.libretroDatabaseID
        guard platformID != Self.unmapped else { return }
        #expect(Self.platforms[platformID] != nil, "\(system) maps to \(platformID), which libretrodb does not have")
    }

    @Test("Only systems filed together in libretrodb share a platform")
    func sharedPlatforms() {
        var systemsByPlatform: [Int: Set<SystemIdentifier>] = [:]
        for system in SystemIdentifier.allCases where system.libretroDatabaseID != Self.unmapped {
            systemsByPlatform[system.libretroDatabaseID, default: []].insert(system)
        }
        let shared = systemsByPlatform.filter { $0.value.count > 1 }
        #expect(shared == Self.sharedPlatforms)
    }

    @Test("A platform used by one system maps back to it", arguments: SystemIdentifier.allCases)
    func roundTrip(_ system: SystemIdentifier) {
        let platformID = system.libretroDatabaseID
        guard platformID != Self.unmapped, Self.sharedPlatforms[platformID] == nil else { return }
        #expect(SystemIdentifier.fromLibretroDatabaseID(platformID) == system)
    }

    // MARK: - Fixtures

    /// What `libretroDatabaseID` returns for a system libretrodb has no platform for.
    static let unmapped = 0

    /// The platforms several systems search on purpose: the flycast arcade
    /// boards on Dreamcast and the Capcom boards on Arcade Games.
    static let sharedPlatforms: [Int: Set<SystemIdentifier>] = [
        41: [.MAME, .CPS1, .CPS2, .CPS3],
        99: [.Dreamcast, .NAOMI, .NAOMI2, .Atomiswave]
    ]

    /// `select id, name from platforms order by id` on the libretrodb in
    /// PVLookup's `databases-2026-11-16` release.
    static let platforms: [Int: String] = [
        1: "Neo Geo CD",
        2: "Mega-CD - Sega CD",
        3: "PC Engine SuperGrafx",
        4: "Quake II",
        5: "Game.com",
        6: "PlayStation",
        7: "Game Master",
        8: "Adventure Vision",
        9: "Neo Geo Pocket",
        10: "DOS",
        11: "Jump 'n Bump",
        12: "PC Engine CD - TurboGrafx-CD",
        13: "PlayStation Vita",
        14: "32X",
        15: "Mega Drive - Genesis",
        16: "Tomb Raider",
        17: "RPG Maker",
        18: "Lutro",
        19: "Cannonball",
        20: "PC-FX",
        21: "Nintendo 3DS",
        22: "Nintendo 64",
        23: "Quake",
        24: "Satellaview",
        25: "Atomiswave",
        26: "TIC-80",
        27: "Handheld Electronic Game",
        28: "Nintendo Entertainment System",
        29: "Jaguar",
        30: "Pokemon Mini",
        31: "Quake III",
        32: "Sufami Turbo",
        33: "WonderSwan",
        34: "7800",
        35: "Odyssey2",
        36: "MSX",
        37: "Super Nintendo Entertainment System",
        38: "2600",
        39: "MAME 2003-Plus",
        40: "Family Computer Disk System",
        41: "Arcade Games",
        42: "e-Reader",
        43: "Arcadia 2001",
        44: "MAME",
        45: "ZX Spectrum +3",
        46: "PV-1000",
        47: "Saturn",
        48: "PlayStation 3",
        49: "Wii (Digital)",
        50: "ZX 81",
        51: "GameCube",
        52: "VIC-20",
        53: "DOOM",
        54: "Channel F",
        55: "ST",
        56: "PlayStation 2",
        57: "Loopy",
        58: "MAME 2003",
        59: "Wolfenstein 3D",
        60: "Dinothawr",
        61: "PlayStation Portable",
        62: "MAME 2016",
        63: "MSX2",
        64: "ZX Spectrum",
        65: "MrBoom",
        66: "MAME 2000",
        67: "MOTO",
        68: "Super Cassette Vision",
        69: "Vectrex",
        70: "Rick Dangerous",
        71: "Neo Geo Pocket Color",
        72: "Uzebox",
        73: "3DO",
        74: "MAME 2015",
        75: "Game Boy",
        76: "SG-1000",
        77: "5200",
        78: "Game Gear",
        79: "Lynx",
        80: "CPC",
        81: "MAME 2010",
        82: "Supervision",
        83: "Master System - Mark III",
        84: "X68000",
        85: "PC-98",
        86: "Game Boy Color",
        87: "GX4000",
        88: "Cave Story",
        89: "Amiga",
        90: "Nintendo DS",
        91: "PICO",
        92: "Intellivision",
        93: "PlayStation Portable (PSN)",
        94: "Leapster Learning Game System",
        95: "Nintendo 64DD",
        96: "WASM-4",
        97: "CreatiVision",
        98: "Super Acan",
        99: "Dreamcast",
        100: "64",
        101: "Wii",
        102: "Videopac+",
        103: "Nintendo DSi",
        104: "V.Smile",
        105: "Xbox",
        106: "PlayStation 3 (PSN)",
        107: "GP32",
        108: "PC Engine - TurboGrafx 16",
        109: "WonderSwan Color",
        110: "ChaiLove",
        111: "LowRes NX",
        112: "Studio II",
        113: "Virtual Boy",
        114: "ColecoVision",
        115: "Game Boy Advance",
        116: "HBMAME",
        117: "Flashback",
        118: "ScummVM",
        119: "Plus-4",
        // Appended by PVLookup's Tools/libretrodb/add_platform.py; not in
        // releases before `databases-2026-11-16`.
        120: "Jaguar CD"
    ]
}
