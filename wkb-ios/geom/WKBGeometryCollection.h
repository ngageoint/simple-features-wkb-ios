//
//  WKBGeometryCollection.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometry.h"

@interface WKBGeometryCollection : WKBGeometry

@property (nonatomic, strong) NSMutableArray * geometries;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(void) addGeometry: (WKBGeometry *) geometry;

-(NSUInteger) numGeometries;

@end
