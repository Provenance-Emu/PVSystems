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
