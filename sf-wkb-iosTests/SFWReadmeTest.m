//
//  SFWReadmeTest.m
//  sf-wkb-iosTests
//
//  Created by Brian Osborn on 7/23/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTestUtils.h"
#import "SFWReadmeTest.h"
#import "SFGeometry.h"
#import "SFPoint.h"
#import "SFWGeometryReader.h"
#import "SFWGeometryWriter.h"

@implementation SFWReadmeTest

static SFGeometry *TEST_GEOMETRY;
static NSData *TEST_DATA;

-(void) setUp{
    TEST_GEOMETRY = [[SFPoint alloc] initWithXValue:1.0 andYValue:1.0];
    const char bytes[] = { 0, 0, 0, 0, 1, 63, -16, 0,
        0, 0, 0, 0, 0, 63, -16, 0, 0, 0, 0, 0, 0 };
    TEST_DATA = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
}

/**
 * Test read
 */
-(void) testRead{
    
    SFGeometry *geometry = [self readTester:TEST_DATA];
    
    [SFWTestUtils assertEqualWithValue:TEST_GEOMETRY andValue2:geometry];
    
}

/**
 * Test read
 *
 * @param bytes
 *            bytes
 * @return geometry
 */
-(SFGeometry *) readTester: (NSData *) data{
    
    // NSData *data = ...
    
    SFGeometry *geometry = [SFWGeometryReader readGeometryWithData:data];
    enum SFGeometryType geometryType = geometry.geometryType;
    
    return geometry;
}

/**
 * Test write
 */
-(void) testWrite{
    
    SFGeometry *geometry = [self readTester:TEST_DATA];
    
    [SFWTestUtils assertEqualWithValue:TEST_GEOMETRY andValue2:geometry];
    
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
    
    NSData *data = [SFWGeometryWriter writeGeometry:geometry];
    
    return data;
}

@end
