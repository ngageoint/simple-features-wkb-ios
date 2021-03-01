# Simple Features WKB iOS

#### Simple Features Well-Known Binary Lib ####

The Simple Features Libraries were developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](https://www.caci.com/bit-systems/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[Simple Features WKB](http://ngageoint.github.io/simple-features-wkb-ios/) is an iOS Objective-C library for writing and reading [Simple Feature](https://github.com/ngageoint/simple-features-ios) Geometries to and from Well-Known Binary.

### Usage ###

View the latest [Appledoc](http://ngageoint.github.io/simple-features-wkb-ios/docs/api/)

#### Read ####

```objectivec

// NSData *data = ...

SFGeometry *geometry = [SFWBGeometryReader readGeometryWithData:data];
enum SFGeometryType geometryType = geometry.geometryType;

```

#### Write ####

```objectivec

// SFGeometry *geometry = ...

NSData *data = [SFWBGeometryWriter writeGeometry:geometry];

```

### Build ###

[![Build & Test](https://github.com/ngageoint/simple-features-wkb-ios/workflows/Build%20&%20Test/badge.svg)](https://github.com/ngageoint/simple-features-wkb-ios/actions?query=workflow%3A%22Build+%26+Test%22)

Build this repository using Xcode and/or CocoaPods:

    pod repo update
    pod install

Open sf-wkb-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'sf-wkb-ios.xcworkspace' -scheme sf-wkb-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'sf-wkb-ios.xcworkspace' -scheme sf-wkb-ios -destination 'platform=iOS Simulator,name=iPhone 12'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/sf-wkb-ios):

    pod 'sf-wkb-ios', '~> 4.0.0'

Pull from GitHub:

    pod 'sf-wkb-ios', :git => 'https://github.com/ngageoint/simple-features-wkb-ios.git', :branch => 'master'
    pod 'sf-wkb-ios', :git => 'https://github.com/ngageoint/simple-features-wkb-ios.git', :tag => '4.0.0'

Include as local project:

    pod 'sf-wkb-ios', :path => '../simple-features-wkb-ios'

### Swift ###

To use from Swift, import the sf-wkb-ios bridging header from the Swift project's bridging header

    #import "sf-wkb-ios-Bridging-Header.h"

#### Read ####

```swift

// var data: Data = ...

let geometry: SFGeometry = SFWBGeometryReader.readGeometry(with: data)
let geometryType: SFGeometryType = geometry.geometryType

```

#### Write ####

```swift

// let geometry: SFGeometry = ...

let data: Data = SFWBGeometryWriter.write(geometry)

```

### Remote Dependencies ###

* [Simple Features](https://github.com/ngageoint/simple-features-ios) (The MIT License (MIT)) - Simple Features Lib
