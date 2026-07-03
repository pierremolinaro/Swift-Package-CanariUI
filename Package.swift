// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//--------------------------------------------------------------------------------------------------

import PackageDescription

//--------------------------------------------------------------------------------------------------

let package = Package (
  name: "CanariUI",
  platforms: [.macOS ("26.0")],
  products: [
    .library (name: "CanariUI", targets: ["CanariUI"]),
  ],
  dependencies: [],
  targets: [
    .target (
      name: "CanariUI",
      dependencies: [],
    ),
    .testTarget (
      name: "SegmentOverlapping",
      dependencies: ["CanariUI"],
    ),
  ]
)

//--------------------------------------------------------------------------------------------------
