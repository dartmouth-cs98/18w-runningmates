//
//  Package.swift
//  RunningMates
//
//  Created by dali on 2/15/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SwiftSMS",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftSMS",
            dependencies: ["Alamofire"]),
        ]
)
