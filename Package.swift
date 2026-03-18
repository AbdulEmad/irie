// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Vitals",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "Vitals",
            path: "Sources/Vitals"
        )
    ]
)
