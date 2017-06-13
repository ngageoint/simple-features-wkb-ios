//
//  WKBPolygon.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolygon.h"
#import "WKBLineString.h"

@implementation WKBPolygon

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:WKB_POLYGON andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBPolygon *polygon = [[WKBPolygon alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBLineString *ring in self.rings){
        [polygon addRing:[ring mutableCopy]];
    }
    return polygon;
}

@end
