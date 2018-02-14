//
//  WKBCentroidPoint.h
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBPoint.h"

/**
 * Calculate the centroid from point based geometries. Implementation based on
 * the JTS (Java Topology Suite) CentroidPoint.
 *
 * @author osbornb
 */
@interface WKBCentroidPoint : NSObject

/**
 *  Initialize
 *
 *  @return new instance
 */
-(instancetype) init;

/**
 *  Initialize
 *
 * @param geometry
 *            geometry to add
 *  @return new instance
 */
-(instancetype) initWithGeometry: (WKBGeometry *) geometry;

/**
 * Add a point based dimension 0 geometry to the centroid total
 *
 * @param geometry
 *            geometry
 */
-(void) addGeometry: (WKBGeometry *) geometry;

/**
 * Get the centroid point
 *
 * @return centroid point
 */
-(WKBPoint *) centroid;

@end
