// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Irie",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "Irie",
            path: "Sources/Irie"
        )
    ]
)
