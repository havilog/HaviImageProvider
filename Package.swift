// swift-tools-version:5.10

import PackageDescription

let package = Package(
  name: "HaviImageProvider",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "HaviImageProvider",
      targets: ["HaviImageProvider"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "HaviImageProvider"),
  ]
)
