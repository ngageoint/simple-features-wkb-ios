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

/**
 * Minimize the geometry using the shortest x distance between each connected set of points.
 * The resulting geometry point x values will be in the range: 
 *   (3 * min value <= x <= 3 * max value
 *
 * Example: For WGS84 provide a max x of 180.0.
 * Resulting x values will be in the range: -540.0 <= x <= 540.0
 *
 * Example: For web mercator provide a world width of 20037508.342789244.
 * Resulting x values will be in the range: -60112525.028367732 <= x <= 60112525.028367732
 *
 * @param geometry
 *            geometry
 * @param maxX
 *            max positive x value in the geometry projection
 */
+(void) minimizeGeometry: (WKBGeometry *) geometry withMaxX: (double) maxX;

/**
 * Normalize the geometry so all points outside of the min and max value range are
 * adjusted to fall within the range.
 *
 * Example: For WGS84 provide a max x of 180.0.
 * Resulting x values will be in the range: -180.0 <= x <= 180.0.
 *
 * Example: For web mercator provide a world width of 20037508.342789244.
 * Resulting x values will be in the range: -20037508.342789244 <= x <= 20037508.342789244.
 *
 * @param geometry
 *            geometry
 * @param maxX
 *            max positive x value in the geometry projection
 */
+(void) normalizeGeometry: (WKBGeometry *) geometry withMaxX: (double) maxX;

@end
