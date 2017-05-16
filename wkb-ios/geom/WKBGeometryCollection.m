//
//  WKBGeometryCollection.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryCollection.h"

@implementation WKBGeometryCollection

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

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

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBGeometryCollection *geometryCollection = [[WKBGeometryCollection alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBGeometry *geometry in self.geometries){
        [geometryCollection addGeometry:[geometry mutableCopy]];
    }
    return geometryCollection;
}

@end
