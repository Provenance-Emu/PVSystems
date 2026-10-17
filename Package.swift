// swift-tools-version:6.0
import PackageDescription

// System identifiers and per-system metadata shared by Provenance, iFly and
// iCube. A leaf package on purpose: it must not depend on any package that
// Provenance keeps in its own tree (PVLogging, PVSupport, ...), or a URL
// consumer and Provenance's local copy would both claim the same package
// identity.
let package = Package(
    name: "PVSystems",
    platforms: [
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v9),
        .macOS(.v14),
        .macCatalyst(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "PVSystems", targets: ["PVSystems"])
    ],
    targets: [
        .target(
            name: "PVSystems",
            resources: [
                // Per-game BIOS manifest (see `PerGameBIOSManifest.swift`).
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PVSystemsTests",
            dependencies: ["PVSystems"]
        )
    ],
    swiftLanguageModes: [.v5, .v6]
)
