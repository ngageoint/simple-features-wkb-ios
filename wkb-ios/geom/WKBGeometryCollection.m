//
//  WKBGeometryCollection.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryCollection.h"

@implementation WKBGeometryCollection

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:WKB_GEOMETRYCOLLECTION andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.geometries = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addGeometry: (WKBGeometry *) geometry{
    [self.geometries addObject:geometry];
}

-(NSNumber *) numGeometries{
    return [NSNumber numberWithInteger:[self.geometries count]];
}

@end
