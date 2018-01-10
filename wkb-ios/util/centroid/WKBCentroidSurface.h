//
//  WKBCentroidSurface.h
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBPoint.h"

/**
 * Calculate the centroid from surface based geometries. Implementation based on
 * the JTS (Java Topology Suite) CentroidArea.
 *
 * @author osbornb
 */
@interface WKBCentroidSurface : NSObject

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
 * Add a surface based dimension 2 geometry to the centroid total. Ignores
 * dimension 0 and 1 geometries.
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
