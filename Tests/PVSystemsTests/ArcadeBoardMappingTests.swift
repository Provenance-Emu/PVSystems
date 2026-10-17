import Testing
@testable import PVSystems

/// The flycast arcade boards (Naomi, Naomi 2, Atomiswave) have no platform of
/// their own in libretrodb or TheGamesDB. These pin the mappings that make
/// their metadata and artwork lookups land somewhere useful.
@Suite("Arcade board mappings")
struct ArcadeBoardMappingTests {
    static let boards: [SystemIdentifier] = [.NAOMI, .NAOMI2, .Atomiswave]

    @Test("libretrodb searches the Dreamcast platform", arguments: boards)
    func libretroPlatform(_ system: SystemIdentifier) {
        #expect(system.libretroDatabaseID == SystemIdentifier.Dreamcast.libretroDatabaseID)
    }

    @Test("TheGamesDB searches the generic Arcade platform", arguments: boards)
    func theGamesDBPlatform(_ system: SystemIdentifier) {
        #expect(system.theGamesDBID == 23)
    }

    // thumbnails.libretro.com folder names (checked 2026-10-17: these return
    // 200; "Sammy - Atomiswave" and "Sega - Atomiswave" return 404).
    @Test("libretro thumbnail folder names")
    func thumbnailFolders() {
        #expect(SystemIdentifier.NAOMI.libretroDatabaseName == "Sega - Naomi")
        #expect(SystemIdentifier.NAOMI2.libretroDatabaseName == "Sega - Naomi 2")
        #expect(SystemIdentifier.Atomiswave.libretroDatabaseName == "Atomiswave")
    }

    // Persisted in both apps' libraries: these must never change.
    @Test("raw values are stable")
    func rawValues() {
        #expect(SystemIdentifier.NAOMI.rawValue == "com.provenance.naomi")
        #expect(SystemIdentifier.NAOMI2.rawValue == "com.provenance.naomi2")
        #expect(SystemIdentifier.Atomiswave.rawValue == "com.provenance.atomiswave")
    }
}
