//
//  SFWBReadmeTest.m
//  sf-wkb-iosTests
//
//  Created by Brian Osborn on 7/23/20.
//  Copyright © 2020 NGA. All rights reserved.
//
@import Foundation;
@import SimpleFeatures;
@import SimpleFeaturesWKB;

#import "SFWBReadmeTest.h"
#import "SFWBTestUtils.h"
#import "SFWBGeometryTestUtils.h"

@implementation SFWBReadmeTest

static SFGeometry *TEST_GEOMETRY;
static NSData *TEST_DATA;

-(void) setUp{
    TEST_GEOMETRY = [SFPoint pointWithXValue:1.0 andYValue:1.0];
    const char bytes[] = { 0, 0, 0, 0, 1, 63, -16, 0,
        0, 0, 0, 0, 0, 63, -16, 0, 0, 0, 0, 0, 0 };
    TEST_DATA = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
}

/**
 * Test read
 */
-(void) testRead{
    
    SFGeometry *geometry = [self readTester:TEST_DATA];
    
    [SFWBTestUtils assertEqualWithValue:TEST_GEOMETRY andValue2:geometry];
    
}

/**
 * Test read
 *
 * @param data
 *            data
 * @return geometry
 */
-(SFGeometry *) readTester: (NSData *) data{
    
    // NSData *data = ...
    
    SFGeometry *geometry = [SFWBGeometryReader readGeometryWithData:data];
//    SFGeometryType geometryType = geometry.geometryType;
    
    return geometry;
}

/**
 * Test write
 */
-(void) testWrite{
    
    NSData *data = [self writeTester:TEST_GEOMETRY];

    [SFWBGeometryTestUtils compareDataWithExpected:TEST_DATA andActual:data];
    
}

/**
 * Test write
 *
 * @param geometry
 *            geometry
 * @return data
 */
-(NSData *) writeTester: (SFGeometry *) geometry{
    
    // SFGeometry *geometry = ...
    
    NSData *data = [SFWBGeometryWriter writeGeometry:geometry];
    
    return data;
}

@end
