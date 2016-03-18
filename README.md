# GeoPackage WKB iOS

#### GeoPackage Well Known Binary Lib ####

The [GeoPackage Libraries](http://ngageoint.github.io/GeoPackage/) were developed at the [National Geospatial-Intelligence Agency (NGA)](http://www.nga.mil/) in collaboration with [BIT Systems](http://www.bit-sys.com/). The government has "unlimited rights" and is releasing this software to increase the impact of government investments by providing developers with the opportunity to take things in new directions. The software use, modification, and distribution rights are stipulated within the [MIT license](http://choosealicense.com/licenses/mit/).

### Pull Requests ###
If you'd like to contribute to this project, please make a pull request. We'll review the pull request and discuss the changes. All pull request contributions to this project will be released under the MIT license.

Software source code previously released under an open source license and then modified by NGA staff is considered a "joint work" (see 17 USC § 101); it is partially copyrighted, partially public domain, and as a whole is protected by the copyrights of the non-government authors and must be released according to the terms of the original open source license.

### About ###

[WKB](http://ngageoint.github.io/geopackage-wkb-ios/) is an iOS Objective-C library for writing and reading Well-Known Binary Geometries to and from bytes. The library includes a hierarchy of Geometry objects. Although developed as part of the [GeoPackage Libraries](http://ngageoint.github.io/GeoPackage/), this library does not contain GeoPackage functionality and can be used separately.

### Usage ###

View the latest [Appledoc on CocoaDocs](http://cocoadocs.org/docsets/wkb-ios)

#### Read ####

    //NSData * bytes = ...    
    
    WKBByteReader * reader = [[WKBByteReader alloc] initWithData:bytes];
    [reader setByteOrder:CFByteOrderBigEndian];
    WKBGeometry * geometry = [WKBGeometryReader readGeometryWithReader:reader];
    WKBGeometryType geometryType = geometry.geometryType;

#### Write ####

    //WKBGeometry * geometry = ...
    
    WKBByteWriter * writer = [[WKBByteWriter alloc] init];
    [writer setByteOrder:CFByteOrderBigEndian];
    [WKBGeometryWriter writeGeometry:geometry withWriter:writer];
    NSData * bytes = [writer getData];
    [writer close];

### Build ###

Build this repository using Xcode and/or CocoaPods:

    pod install

Open wkb-ios.xcworkspace in Xcode or build from command line:

    xcodebuild -workspace 'wkb-ios.xcworkspace' -scheme wkb-ios build

Run tests from Xcode or from command line:

    xcodebuild test -workspace 'wkb-ios.xcworkspace' -scheme wkb-ios -destination 'platform=iOS Simulator,name=iPhone 6s'

### Include Library ###

Include this repository by specifying it in a Podfile using a supported option.

Pull from [CocoaPods](https://cocoapods.org/pods/wkb-ios):

    pod 'wkb-ios', '~> 1.0'

Pull from GitHub:

    pod 'wkb-ios', :git => 'https://github.com/ngageoint/geopackage-wkb-iOS.git', :branch => 'master'
    pod 'wkb-ios', :git => 'https://github.com/ngageoint/geopackage-wkb-iOS.git', :tag => '1.0.6'

Include as local project:

    pod 'wkb-ios', :path => '../geopackage-wkb-ios'

### Swift ###

To use from Swift, import the wkb-ios bridging header from the Swift project's bridging header

    #import "wkb-ios-Bridging-Header.h"

#### Read ####

    // let bytes: NSData = ...
    
    let reader: WKBByteReader = WKBByteReader(data: bytes);
    reader.byteOrder = Int(CFByteOrderBigEndian.rawValue);
    let geometry: WKBGeometry = WKBGeometryReader.readGeometryWithReader(reader);
    let geometryType: WKBGeometryType = geometry.geometryType;

#### Write ####

    //let geometry: WKBGeometry = ...
    
    let writer: WKBByteWriter = WKBByteWriter();
    writer.byteOrder = Int(CFByteOrderBigEndian.rawValue);
    WKBGeometryWriter.writeGeometry(geometry, withWriter: writer);
    let bytes: NSData = writer.getData();
    writer.close();
