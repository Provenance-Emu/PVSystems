// swift-tools-version:6.0
import Foundation
import PackageDescription

// System identifiers and per-system metadata shared by Provenance, iFly and
// iCube. A leaf package on purpose: it must not depend on any package that
// Provenance keeps in its own tree (PVLogging, PVSupport, ...), or a URL
// consumer and Provenance's local copy would both claim the same package
// identity.
// A version tag resolves to the prebuilt XCFramework from that tag's GitHub release;
// `main` always builds from source. The release workflow fills this in on the tagged
// commit only, so it stays `nil` on every branch.
// Set PV_BUILD_FROM_SOURCE=1 to build a tagged version from source instead.
let binaryRelease: (version: String, checksums: [String: String])? = ("1.0.3", ["PVSystems": "bfb20983fb8db79c5ba740f45b38f907d20fb97e93d0cb78c8d7738e2ccc6919"])

let environment = ProcessInfo.processInfo.environment
let buildFromSource = binaryRelease == nil || environment["PV_BUILD_FROM_SOURCE"] != nil
// The release workflow builds the framework it publishes from a dynamic product.
let libraryType: Product.Library.LibraryType? = environment["PV_XCFRAMEWORK_BUILD"] != nil ? .dynamic : nil

let sourceTargets: [Target] = [
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
]

let binaryTargets: [Target] = binaryRelease.map { release in
    release.checksums.sorted { $0.key < $1.key }.map { module, checksum in
        .binaryTarget(
            name: module,
            url: "https://github.com/Provenance-Emu/PVSystems/releases/download/\(release.version)/\(module).xcframework.zip",
            checksum: checksum
        )
    }
} ?? []

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
        .library(name: "PVSystems", type: buildFromSource ? libraryType : nil, targets: ["PVSystems"])
    ],
    targets: buildFromSource ? sourceTargets : binaryTargets,
    swiftLanguageModes: [.v5, .v6]
)
