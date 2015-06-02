//
//  WKBMultiPoint.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiPoint.h"

@implementation WKBMultiPoint

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_MULTIPOINT andHasZ:hasZ andHasM:hasM];
    return self;
}

-(NSMutableArray *) getPoints{
    return [self geometries];
}

-(void) setPoints: (NSMutableArray *) points{
    [self setGeometries:points];
}

-(void) addPoint: (WKBPoint *) point{
    [self addGeometry:point];
}

-(NSNumber *) numPoints{
    return [self numGeometries];
}

@end
