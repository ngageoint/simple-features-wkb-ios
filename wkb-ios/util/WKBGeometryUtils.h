//
//  WKBGeometryUtils.h
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometry.h"
#import "WKBPoint.h"

/**
 * Utilities for Geometry objects
 *
 * @author osbornb
 */
@interface WKBGeometryUtils : NSObject

/**
 * Get the dimension of the Geometry, 0 for points, 1 for curves, 2 for
 * surfaces. If a collection, the largest dimension is returned.
 *
 * @param geometry
 *            geometry object
 * @return dimension (0, 1, or 2)
 */
+(int) dimensionOfGeometry: (WKBGeometry *) geometry;

/**
 * Get the Pythagorean theorem distance between two points
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return distance
 */
+(double) distanceBetweenPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2;

/**
 * Get the centroid point of the Geometry
 *
 * @param geometry
 *            geometry object
 * @return centroid point
 */
+(WKBPoint *) centroidOfGeometry: (WKBGeometry *) geometry;

@end
