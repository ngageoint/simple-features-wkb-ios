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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:.5 andYValue:1]];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:(int)points.count];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:100]];
    [points addObject:[[WKBPoint alloc] initWithXValue:100 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:200 andYValue:100]];
    [points addObject:[[WKBPoint alloc] initWithXValue:100 andYValue:200]];
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:100]];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:5 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8384094 andYValue:39.753657]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8377228 andYValue:39.7354422]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.7930908 andYValue:39.7364983]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8233891 andYValue:39.7440222]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.7930908 andYValue:39.7369603]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.808197 andYValue:39.7541849]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8383236 andYValue:39.753723]];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:7 andValue2:(int)points.count];

    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:-106.3256836 andYValue:40.2962865]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.6445313 andYValue:38.5911138]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.0842285 andYValue:40.3046654]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.6445313 andYValue:38.5911139]];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
}

- (void)testNonSimple {
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:(int)points.count];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:0]];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:(int)points.count];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:100]];
    [points addObject:[[WKBPoint alloc] initWithXValue:100 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:200 andYValue:100]];
    [points addObject:[[WKBPoint alloc] initWithXValue:100 andYValue:200]];
    [points addObject:[[WKBPoint alloc] initWithXValue:100.01 andYValue:200]];
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:100]];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:6 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8384094 andYValue:39.753657]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8377228 andYValue:39.7354422]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.7930908 andYValue:39.7364983]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8233891 andYValue:39.7440222]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8034763 andYValue:39.7387424]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.7930908 andYValue:39.7369603]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.808197 andYValue:39.7541849]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-104.8383236 andYValue:39.753723]];

    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:8 andValue2:(int)points.count];
    
    [points removeAllObjects];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:-106.3256836 andYValue:40.2962865]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.6445313 andYValue:38.5911138]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.0842285 andYValue:40.3046654]];
    [points addObject:[[WKBPoint alloc] initWithXValue:-105.6445313 andYValue:38.5911138]];

    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygonPoints:points]];
    [WKBTestUtils assertEqualIntWithValue:4 andValue2:(int)points.count];
    
}

- (void)testSimpleHole {
    
    WKBPolygon *polygon = [[WKBPolygon alloc] init];
    
    NSMutableArray<WKBPoint *> *points = [[NSMutableArray alloc] init];
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:9 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:9]];
    
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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:9 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:9]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:5.000001 andYValue:9]];
    
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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:9 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints1 = [[NSMutableArray alloc] init];
    
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:1]];
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:9 andYValue:1]];
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:9]];
    
    WKBLineString *hole1 = [[WKBLineString alloc] init];
    hole1.points = holePoints1;
    
    [polygon addRing:hole1];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints2 = [[NSMutableArray alloc] init];
    
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:5.0 andYValue:0.1]];
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:6.0 andYValue:0.1]];
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:5.5 andYValue:1.00001]];
    
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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints1 = [[NSMutableArray alloc] init];
    
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:1 andYValue:1]];
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:9 andYValue:1]];
    [holePoints1 addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:9]];
    
    WKBLineString *hole1 = [[WKBLineString alloc] init];
    hole1.points = holePoints1;
    
    [polygon addRing:hole1];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];

    NSMutableArray<WKBPoint *> *holePoints2 = [[NSMutableArray alloc] init];
    
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:2 andYValue:2]];
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:8 andYValue:2]];
    [holePoints2 addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:8]];
    
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
    
    [points addObject:[[WKBPoint alloc] initWithXValue:0 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:10 andYValue:0]];
    [points addObject:[[WKBPoint alloc] initWithXValue:5 andYValue:10]];
    
    WKBLineString *ring = [[WKBLineString alloc] init];
    ring.points = points;
    
    [polygon addRing:ring];
    
    [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:1 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    
    NSMutableArray<WKBPoint *> *holePoints = [[NSMutableArray alloc] init];
    
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:-1 andYValue:1]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:-1 andYValue:3]];
    [holePoints addObject:[[WKBPoint alloc] initWithXValue:-2 andYValue:1]];
    
    WKBLineString *hole = [[WKBLineString alloc] init];
    hole.points = holePoints;
    
    [polygon addRing:hole];
    
    [WKBTestUtils assertFalse:[WKBShamosHoey simplePolygon:polygon]];
    [WKBTestUtils assertEqualIntWithValue:2 andValue2:[[polygon numRings] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:0]) numPoints] intValue]];
    [WKBTestUtils assertEqualIntWithValue:3 andValue2:[[((WKBLineString *)[polygon.rings objectAtIndex:1]) numPoints] intValue]];
    
}

- (void)testLargeSimple {
    
    double increment = .001;
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
        [points addObject:[[WKBPoint alloc] initWithXValue:x andYValue:y]];
        x += increment;
    }
    
    x = radius - increment;
    while (x >= -radius) {
        if (x >= 0) {
            y += increment;
        } else {
            y -= increment;
        }
        [points addObject:[[WKBPoint alloc] initWithXValue:x andYValue:y]];
        x -= increment;
    }
    
    [self measureBlock:^{
        [WKBTestUtils assertTrue:[WKBShamosHoey simplePolygonPoints:points]];
    }];
    [WKBTestUtils assertEqualIntWithValue:(int) (radius / increment * 4) andValue2:(int)points.count];
    
}

@end
