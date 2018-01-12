//
//  WKBSweepLine.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBSweepLine.h"

@interface WKBSweepLine()

@property (nonatomic, strong) NSArray<WKBLineString *> *rings;

@end

@implementation WKBSweepLine

-(instancetype) initWithRings: (NSArray<WKBLineString *> *) rings{
    self = [super init];
    if(self != nil){
        self.rings = rings;
    }
    return self;
}

-(WKBSegment *) addEvent: (WKBEvent *) event{
    // TODO
    return nil;
}

-(WKBSegment *) findEvent: (WKBEvent *) event{
    // TODO
    return nil;
}

-(BOOL) intersectWithSegment: (WKBSegment *) segment1 andSegment: (WKBSegment *) segment2{
    // TODO
    return NO;
}

-(void) removeSegment: (WKBSegment *) segment{
    // TODO
}

+(NSComparisonResult) xyOrderWithPoint: (WKBPoint *) point1 andPoint: (WKBPoint *) point2{
    // TODO
    return NSOrderedSame;
}

@end
