//
//  WKBLineString.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCurve.h"
#import "WKBPoint.h"

/**
 * A Curve that connects two or more points in space.
 */
@interface WKBLineString : WKBCurve

/**
 *  Array of points
 */
@property (nonatomic, strong) NSMutableArray * points;

/**
 *  Initialize
 *
 *  @return new line string
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new line string
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new line string
 */
-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

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
