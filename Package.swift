// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AsbPurchasesUiCapacitor",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AsbPurchasesUiCapacitor",
            targets: ["ASBPurchasesUIPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "ASBPurchasesUIPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/ASBPurchasesUIPlugin"),
        .testTarget(
            name: "ASBPurchasesUIPluginTests",
            dependencies: ["ASBPurchasesUIPlugin"],
            path: "ios/Tests/ASBPurchasesUIPluginTests")
    ]
)