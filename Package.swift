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
     revision: "c47dcec2b15b152568f2e929b978aa44a43ff699"
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
