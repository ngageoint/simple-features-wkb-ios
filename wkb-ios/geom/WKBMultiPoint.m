//
//  WKBMultiPoint.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiPoint.h"

@implementation WKBMultiPoint

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

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

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBMultiPoint *multiPoint = [[WKBMultiPoint alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBPoint *point in self.geometries){
        [multiPoint addPoint:[point mutableCopy]];
    }
    return multiPoint;
}

@end
