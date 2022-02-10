# Change Log
All notable changes to this project will be documented in this file.
Adheres to [Semantic Versioning](http://semver.org/).

---

## [4.0.1](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/4.0.1) (02-10-2022)

* sf-ios 4.0.1

## [4.0.0](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/4.0.0) (03-01-2021)

* sf-ios 4.0.0
* iOS platform and deployment target 12.0
* Geometry reader/writer instance methods

## [3.0.0](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/3.0.0) (08-14-2020)

* sf-ios 3.0.0
* Class prefixes changed from SFW to SFWB, to better coincide with SFWT (Well-Known Text) library
* Geometry reader/writer shortcut support directly between bytes and geometries
* Geometry Filter support
* Geometry Code retrieval method by geometry type, has z, and has m

## [2.0.3](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/2.0.3) (10-14-2019)

* sf-ios 2.0.3

## [2.0.2](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/2.0.2) (04-03-2019)

* sf-ios 2.0.2

## [2.0.1](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/2.0.1) (09-25-2018)

* sf-ios 2.0.1
* Xcode 10 fix

## [2.0.0](https://github.com/ngageoint/simple-features-wkb-ios/releases/tag/2.0.0) (05-18-2018)

* Simple Features refactor, geopackage-wkb-ios refactored to be simple-features-wkb-ios
* Class prefixes changed from "WKB" to "SFW"
* Common simple features code moved to new dependency, [simple-features-ios](https://github.com/ngageoint/simple-features-ios). Requires class prefix changes from "WKB" to "SF".
* Geometry Codes WKB utility class
* MultiCurve and MultiSurface read support
* MultiCurve and MultiSurface write support as Extended Geometry Collections
* Geometry Collection utility methods for collection type checks and conversions
* Handle reading 2.5D geometry type codes

## [1.0.9](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.9) (02-14-2018)

* Additional Curve Polygon support
* Geometry utilities: pointInPolygon, pointOnPolygonEdge, closedPolygon, pointOnLine, and pointOnPath
* Shamos-Hoey simple polygon detection

## [1.0.8](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.8) (11-21-2017)

* Douglas Peucker algorithm for geometry simplification

## [1.0.7](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.7) (06-13-2017)

* Shortcut default initializers for Geometry objects without z or m values
* Geometry utilities including centroid, minimize for antimeridian support, and normalize
* Geometry mutable copying support (NSMutableCopying)
* Geometry encoding & decoding support (NSCoding)

## [1.0.6](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.6)  (03-18-2016)

* Adding Geometry JSON Compatible utility to the bridging header

## [1.0.5](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.5)  (03-17-2016)

* Geometry JSON compatible object utility

## [1.0.4](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.4)  (02-08-2016)

* Removed CFBundleExecutable key from bundle

## [1.0.3](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.3)  (11-23-2015)

* Bridging Header for Swift

## [1.0.2](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.2)  (11-12-2015)

* Added tests
* Minor podspec updates

## [1.0.1](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.1)  (11-04-2015)

* Minor podspec updates

## [1.0.0](https://github.com/ngageoint/geopackage-wkb-ios/releases/tag/1.0.0)  (10-27-2015)

* Initial Release
