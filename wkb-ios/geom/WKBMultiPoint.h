//
//  WKBMultiPoint.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryCollection.h"
#import "WKBPoint.h"

/**
 * A restricted form of GeometryCollection where each Geometry in the collection
 * must be of type Point.
 */
@interface WKBMultiPoint : WKBGeometryCollection

/**
 *  Initialize
 *
 *  @return new multi point
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi point
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the points
 *
 *  @return points
 */
-(NSMutableArray *) getPoints;

/**
 *  Set the points
 *
 *  @param points points
 */
-(void) setPoints: (NSMutableArray *) points;

/**
 *  Add a point
 *
 *  @param point point
 */
-(void) addPoint: (WKBPoint *) point;

/**
 *  Get the number of points
 *
 *  @return point count
 */
-(NSNumber *) numPoints;

@end
