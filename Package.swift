// swift-tools-version: 6.0
//--------------------------------------------------------------------------------------------------

import PackageDescription

//--------------------------------------------------------------------------------------------------

let package = Package (
  name: "CanariUI",
  platforms: [.macOS ("26")],
  products: [
    .library (name: "CanariUI", targets: ["CanariUI"]),
  ],
  dependencies: [
   .package (
     url: "https://github.com/pierremolinaro/Swift-Package-CanariGeometry",
     revision: "40eb5419cc487526eeb8a3796c27ca5cace57b7d"
   )
//    .package (path: "../Swift-Package-CanariGeometry")
  ],
  targets: [
    .target (
      name: "CanariUI",
      dependencies: [
        .product (name: "CanariGeometry", package: "Swift-Package-CanariGeometry")
      ]
    ),
    .testTarget (
      name: "SegmentOverlapping",
      dependencies: ["CanariUI"],
    ),
  ],
  swiftLanguageModes: [.v6]
)

//--------------------------------------------------------------------------------------------------
