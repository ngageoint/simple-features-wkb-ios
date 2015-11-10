//
//  WKBTestCase.m
//  wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WKBTestUtils.h"
#import "WKBGeometryTestUtils.h"

@interface WKBTestCase : XCTestCase

@end

@implementation WKBTestCase

static NSUInteger GEOMETRIES_PER_TEST = 10;

-(void) setUp {
    [super setUp];
}

-(void) tearDown {
    [super tearDown];
}

-(void) testPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a point
        WKBPoint * point = [WKBGeometryTestUtils createPointWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: point];
    }
}

-(void) testLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a line string
        WKBLineString * lineString = [WKBGeometryTestUtils createLineStringWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: lineString];
    }
}

-(void) testPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a polygon
        WKBPolygon * polygon = [WKBGeometryTestUtils createPolygonWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: polygon];
    }
}

-(void) testMultiPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi point
        WKBMultiPoint * multiPoint = [WKBGeometryTestUtils createMultiPointWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: multiPoint];
    }
}

-(void) testMultiLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi line string
        WKBMultiLineString * multiLineString = [WKBGeometryTestUtils createMultiLineStringWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: multiLineString];
    }
}

-(void) testMultiPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi polygon
        WKBMultiPolygon * multiPolygon = [WKBGeometryTestUtils createMultiPolygonWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: multiPolygon];
    }
}

-(void) testGeometryCollection {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a geometry collection
        WKBGeometryCollection * geometryCollection = [WKBGeometryTestUtils createGeometryCollectionWithHasZ:[WKBTestUtils coinFlip] andHasM:[WKBTestUtils coinFlip]];
        [self geometryTester: geometryCollection];
    }
}

-(void) geometryTester: (WKBGeometry *) geometry{
    
    // Write the geometries to bytes
    NSData * data1 = [WKBGeometryTestUtils writeDataWithGeometry:geometry andByteOrder:CFByteOrderBigEndian];
    NSData * data2 = [WKBGeometryTestUtils writeDataWithGeometry:geometry andByteOrder:CFByteOrderLittleEndian];
    
    [WKBTestUtils assertFalse:[WKBGeometryTestUtils equalDataWithExpected:data1 andActual:data2]];
    
    // Test that the bytes are read using their written byte order, not
    // the specified
    WKBGeometry * geometry1opposite = [WKBGeometryTestUtils readGeometryWithData:data1 andByteOrder:CFByteOrderLittleEndian];
    WKBGeometry * geometry2opposite = [WKBGeometryTestUtils readGeometryWithData:data2 andByteOrder:CFByteOrderBigEndian];
    [WKBGeometryTestUtils compareDataWithExpected:[WKBGeometryTestUtils writeDataWithGeometry:geometry]
                                        andActual:[WKBGeometryTestUtils writeDataWithGeometry:geometry1opposite]];
    [WKBGeometryTestUtils compareDataWithExpected:[WKBGeometryTestUtils writeDataWithGeometry:geometry]
                                        andActual:[WKBGeometryTestUtils writeDataWithGeometry:geometry2opposite]];
    
    WKBGeometry * geometry1 = [WKBGeometryTestUtils readGeometryWithData:data1 andByteOrder:CFByteOrderBigEndian];
    WKBGeometry * geometry2 = [WKBGeometryTestUtils readGeometryWithData:data2 andByteOrder:CFByteOrderLittleEndian];
    
    [WKBGeometryTestUtils compareGeometriesWithExpected:geometry andActual:geometry1];
    [WKBGeometryTestUtils compareGeometriesWithExpected:geometry andActual:geometry2];
    [WKBGeometryTestUtils compareGeometriesWithExpected:geometry1 andActual:geometry2];

}

@end
