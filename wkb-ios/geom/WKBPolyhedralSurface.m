//
//  WKBPolyhedralSurface.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolyhedralSurface.h"

@implementation WKBPolyhedralSurface

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self initWithType:WKB_POLYHEDRALSURFACE andHasZ:hasZ andHasM:hasM];
}

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:geometryType andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.polygons = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addPolygon: (WKBPolygon *) polygon{
    [self.polygons addObject:polygon];
}

-(NSNumber *) numPolygons{
    return [NSNumber numberWithInteger:[self.polygons count]];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBPolyhedralSurface *polyhedralSurface = [[WKBPolyhedralSurface alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBPolygon *polygon in self.polygons){
        [polyhedralSurface addPolygon:[polygon mutableCopy]];
    }
    return polyhedralSurface;
}

@end
