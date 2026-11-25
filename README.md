# PVSystems

`SystemIdentifier` and the per-system metadata that Provenance, iFly and iCube share:
display names and manufacturers, libretro / OpenVGDB / TheGamesDB / ShiraGame / RetroAchievements
platform mappings, BIOS directory names, box-art aspect ratios, and the per-game BIOS manifest.

```swift
.package(url: "https://github.com/Provenance-Emu/PVSystems.git", .upToNextMajor(from: "1.0.0"))
```

It has no dependencies, and it must stay that way: a package that Provenance also keeps in its own
tree (PVLogging, PVSupport, …) can't be a dependency here, because SwiftPM would then see two packages
with the same identity.

`SystemIdentifier` raw values are persisted in both apps' libraries. Never change or remove one;
add a new case instead.

Seeded on 2026-10-17 from Provenance's `PVPrimitives/Sources/PVSystems` (Provenance-Emu/Provenance
`9529d8509c`) and reconciled with iFly's copy.

## Prebuilt XCFramework

A version tag resolves to a prebuilt XCFramework: the tag's `Package.swift` is a
`binaryTarget` pointing at the tag's GitHub Release, so an app that depends on a version
compiles none of this package. `main` and every other branch build from source.

To build a tagged version from source (to step into it in the debugger, say), set
`PV_BUILD_FROM_SOURCE=1` in the environment `xcodebuild` or Xcode starts in, then resolve
packages again.

To release, run **Release XCFramework** from the Actions tab with the new version. Do not
push version tags by hand: such a tag has no binary and builds from source.
[How releases work](https://github.com/Provenance-Emu/.github/blob/main/docs/xcframework-releases.md).
