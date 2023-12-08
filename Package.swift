// swift-tools-version: 5.9
import PackageDescription

var inputFiles: [Resource] = (1...25)
    .map { "Day \($0)/Day\($0).input" }
    .map {  .process($0) }
//TODO: add in any part 2 test files here.... AGGHRHRHRH

let package = Package(
    name: "AdventOfCode",
    platforms: [
        //.iOS(.v15),
        .macOS(.v13)
    ],
    dependencies: [
        // Some recommended packages here, you might like to try them!
        
        // Sequence and collection algorithms
        // i.e. rotations, permutations, etc.
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        
        // Extra data structure implementations
        // i.e. OrderedSet, Deque, Heap
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0"))
        
        // Support for numerical computing, including complex numbers
        //.package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(name: "AdventOfCode", dependencies: [.product(name: "Collections", package: "swift-collections"),.product(name: "Algorithms", package: "swift-algorithms")],resources: inputFiles),
        .testTarget(name: "AdventOfCodeTests", dependencies: ["AdventOfCode"], resources: inputFiles)
    ]
)


let swiftSettings: [SwiftSetting] = [
    // -enable-bare-slash-regex becomes
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    // -warn-concurrency becomes
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags(["-enable-actor-data-race-checks"],
        .when(configuration: .debug)),
]

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: swiftSettings)
}
