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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
