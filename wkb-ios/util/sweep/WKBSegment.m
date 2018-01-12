//
//  WKBSegment.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBSegment.h"

@interface WKBSegment()

/**
 * Edge number
 */
@property (nonatomic) int edge;

/**
 * Polygon ring number
 */
@property (nonatomic) int ring;

/**
 * Left point
 */
@property (nonatomic, strong) WKBPoint *leftPoint;

/**
 * Right point
 */
@property (nonatomic, strong) WKBPoint *rightPoint;

@end

@implementation WKBSegment

-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                andLeftPoint: (WKBPoint *) leftPoint
               andRightPoint: (WKBPoint *) rightPoint{
    self = [super init];
    if(self != nil){
        self.edge = edge;
        self.ring = ring;
        self.leftPoint = leftPoint;
        self.rightPoint = rightPoint;
    }
    return self;
}

-(int) edge{
    return _edge;
}

-(int) ring{
    return _ring;
}

-(WKBPoint *) leftPoint{
    return _leftPoint;
}

-(WKBPoint *) rightPoint{
    return _rightPoint;
}

@end
