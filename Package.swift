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
     revision: "3552a4c01111d84e84e4f1cfb5b96dde63b51ce7"
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
