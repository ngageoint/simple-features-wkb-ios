//
//  WKBCurvePolygon.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCurvePolygon.h"

@implementation WKBCurvePolygon

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:WKB_CURVEPOLYGON andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.rings = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addRing: (WKBCurve *) ring{
    [self.rings addObject:ring];
}

-(NSNumber *) numRings{
    return [NSNumber numberWithInteger:[self.rings count]];
}

@end
