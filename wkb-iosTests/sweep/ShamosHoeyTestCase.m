//
//  ShamosHoeyTestCase.m
//  wkb-iosTests
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WKBTestUtils.h"
#import "WKBShamosHoey.h"

@interface ShamosHoeyTestCase : XCTestCase

@end

@implementation ShamosHoeyTestCase

-(void) setUp {
    [super setUp];
}

-(void) tearDown {
    [super tearDown];
}

- (void)testSimple {

    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:1 andY:0];
    [self addPoint:points withX:.5 andY:1];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:(int)points.count];
    
    [self addPoint:points withX:0 andY:0];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [self addPoint:points withX:0 andY:100];
    [self addPoint:points withX:100 andY:0];
    [self addPoint:points withX:200 andY:100];
    [self addPoint:points withX:100 andY:200];
    [self addPoint:points withX:0 andY:100];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:5 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [self addPoint:points withX:-104.8384094 andY:39.753657];
    [self addPoint:points withX:-104.8377228 andY:39.7354422];
    [self addPoint:points withX:-104.7930908 andY:39.7364983];
    [self addPoint:points withX:-104.8233891 andY:39.7440222];
    [self addPoint:points withX:-104.7930908 andY:39.7369603];
    [self addPoint:points withX:-104.808197 andY:39.7541849];
    [self addPoint:points withX:-104.8383236 andY:39.753723];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:7 andValue2:(int)points.count];

    [points removeAllObjects];
    
    [self addPoint:points withX:-106.3256836 andY:40.2962865];
    [self addPoint:points withX:-105.6445313 andY:38.5911138];
    [self addPoint:points withX:-105.0842285 andY:40.3046654];
    [self addPoint:points withX:-105.6445313 andY:38.5911139];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
}

- (void)testNonSimple {
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:(int)points.count];
    
    [self addPoint:points withX:1 andY:0];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:(int)points.count];
    
    [self addPoint:points withX:0 andY:0];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [self addPoint:points withX:0 andY:100];
    [self addPoint:points withX:100 andY:0];
    [self addPoint:points withX:200 andY:100];
    [self addPoint:points withX:100 andY:200];
    [self addPoint:points withX:100.01 andY:200];
    [self addPoint:points withX:0 andY:100];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:6 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [self addPoint:points withX:-104.8384094 andY:39.753657];
    [self addPoint:points withX:-104.8377228 andY:39.7354422];
    [self addPoint:points withX:-104.7930908 andY:39.7364983];
    [self addPoint:points withX:-104.8233891 andY:39.7440222];
    [self addPoint:points withX:-104.8034763 andY:39.7387424];
    [self addPoint:points withX:-104.7930908 andY:39.7369603];
    [self addPoint:points withX:-104.808197 andY:39.7541849];
    [self addPoint:points withX:-104.8383236 andY:39.753723];

    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:8 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [self addPoint:points withX:-106.3256836 andY:40.2962865];
    [self addPoint:points withX:-105.6445313 andY:38.5911138];
    [self addPoint:points withX:-105.0842285 andY:40.3046654];
    [self addPoint:points withX:-105.6445313 andY:38.5911138];

    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
    
}

- (void)testSimpleHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints withX:1 andY:1];
    [self addPoint:holePoints withX:9 andY:1];
    [self addPoint:holePoints withX:5 andY:9];
    
    WKBLineString *hole = [[WKBLineString alloc] init];
    hole.points = holePoints;
    
    [polygon addRing:hole];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];

}

- (void)testNonSimpleHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints withX:1 andY:1];
    [self addPoint:holePoints withX:9 andY:1];
    [self addPoint:holePoints withX:5 andY:9];
    [self addPoint:holePoints withX:5.000001 andY:9];
    
    WKBLineString *hole = [[WKBLineString alloc] init];
    hole.points = holePoints;
    
    [polygon addRing:hole];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    
}

- (void)testIntersectingHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints withX:1 andY:1];
    [self addPoint:holePoints withX:9 andY:1];
    [self addPoint:holePoints withX:5 andY:10];
    
    WKBLineString *hole = [[WKBLineString alloc] init];
    hole.points = holePoints;
    
    [polygon addRing:hole];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];

}

- (void)testIntersectingHoles {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints1 = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints1 withX:1 andY:1];
    [self addPoint:holePoints1 withX:9 andY:1];
    [self addPoint:holePoints1 withX:5 andY:9];
    
    WKBLineString *hole1 = [[WKBLineString alloc] init];
    hole1.points = holePoints1;
    
    [polygon addRing:hole1];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints2 = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints2 withX:5.0 andY:0.1];
    [self addPoint:holePoints2 withX:6.0 andY:0.1];
    [self addPoint:holePoints2 withX:5.5 andY:1.00001];
    
    WKBLineString *hole2 = [[WKBLineString alloc] init];
    hole2.points = holePoints2;
    
    [polygon addRing:hole2];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:2]) numPoints] intValue]];

}

- (void)testHoleInsideHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints1 = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints1 withX:1 andY:1];
    [self addPoint:holePoints1 withX:9 andY:1];
    [self addPoint:holePoints1 withX:5 andY:9];
    
    WKBLineString *hole1 = [[WKBLineString alloc] init];
    hole1.points = holePoints1;
    
    [polygon addRing:hole1];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];

    NSMutableArray<WKBPoint *> *holePoints2 = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints2 withX:2 andY:2];
    [self addPoint:holePoints2 withX:8 andY:2];
    [self addPoint:holePoints2 withX:5 andY:8];
    
    WKBLineString *hole2 = [[WKBLineString alloc] init];
    hole2.points = holePoints2;
    
    [polygon addRing:hole2];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:2]) numPoints] intValue]];

}

- (void)testExternalHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [self addPoint:points withX:0 andY:0];
    [self addPoint:points withX:10 andY:0];
    [self addPoint:points withX:5 andY:10];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [self addPoint:holePoints withX:-1 andY:1];
    [self addPoint:holePoints withX:-1 andY:3];
    [self addPoint:holePoints withX:-2 andY:1];
    
    WKBLineString *hole = [[WKBLineString alloc] init];
    hole.points = holePoints;
    
    [polygon addRing:hole];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    
}

- (void)testLargeSimple {
    
    double increment = .01;
    double radius = 1250;
    double x = -radius + increment;
    double y = 0;
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    while (x <= radius) {
        if (x <= 0) {
            y -= increment;
        } else {
            y += increment;
        }
        [self addPoint:points withX:x andY:y];
        x += increment;
    }
    
    x = radius - increment;
    while (x >= -radius) {
        if (x >= 0) {
            y += increment;
        } else {
            y -= increment;
        }
        [self addPoint:points withX:x andY:y];
        x -= increment;
    }
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:(int) (radius / increment * 4) andValue2:(int)points.count];
    
}

- (void)testLargeNonSimple {
    
    double increment = .01;
    double radius = 1250;
    double x = -radius + increment;
    double y = 0;
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    while (x <= radius) {
        if (x <= 0) {
            y -= increment;
        } else {
            y += increment;
        }
        [self addPoint:points withX:x andY:y];
        x += increment;
    }
    
    WKBPoint *previousPoint = [points objectAtIndex:points.count - 2];
    int invalidIndex = (int)points.count;
    [self addPoint:points withX:[previousPoint.x doubleValue] andY:[previousPoint.y doubleValue] - .000001];
    
    x = radius - increment;
    while (x >= -radius) {
        if (x >= 0) {
            y += increment;
        } else {
            y -= increment;
        }
        [self addPoint:points withX:x andY:y];
        x -= increment;
    }
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:1 + (int) (radius / increment * 4) andValue2:(int)points.count];

    [points removeObjectAtIndex:invalidIndex];
    previousPoint = [points objectAtIndex:points.count - 3];
    [self addPoint:points withX:[previousPoint.x doubleValue] andY:[previousPoint.y doubleValue] + .000000000000001];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:1 + (int) (radius / increment * 4) andValue2:(int)points.count];

}

-(void) addPoint: (NSMutableArray<WKBPoint *> *) points withX: (double) x andY: (double) y{
    [points addObject:[[WKBPoint alloc] initWithXValue:x andYValue:y]];
}

@end
