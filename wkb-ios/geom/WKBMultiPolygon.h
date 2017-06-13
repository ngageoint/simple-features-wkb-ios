//
//  WKBMultiPolygon.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiSurface.h"
#import "WKBPolygon.h"

/**
 * A restricted form of MultiSurface where each Surface in the collection must
 * be of type Polygon.
 */
@interface WKBMultiPolygon : WKBMultiSurface

/**
 *  Initialize
 *
 *  @return new multi polygon
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi polygon
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the polygons
 *
 *  @return polygons
 */
-(NSMutableArray *) getPolygons;

/**
 *  Set the polygons
 *
 *  @param polygons polygons
 */
-(void) setPolygons: (NSMutableArray *) polygons;

/**
 *  Add a polygon
 *
 *  @param polygon polygon
 */
-(void) addPolygon: (WKBPolygon *) polygon;

/**
 *  Get the number of polygons
 *
 *  @return polygon count
 */
-(NSNumber *) numPolygons;

@end
