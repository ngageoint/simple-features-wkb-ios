//
//  WKBGeometryCollection.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometry.h"

/**
 *  A collection of zero or more Geometry instances.
 */
@interface WKBGeometryCollection : WKBGeometry

/**
 *  Array of geometries
 */
@property (nonatomic, strong) NSMutableArray * geometries;

/**
 *  Initialize
 *
 *  @return new geometry collection
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new geometry collection
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new geometry collection
 */
-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Add geometry
 *
 *  @param geometry geometry
 */
-(void) addGeometry: (WKBGeometry *) geometry;

/**
 *  Get the number of geometries
 *
 *  @return geometry count
 */
-(NSNumber *) numGeometries;

@end
