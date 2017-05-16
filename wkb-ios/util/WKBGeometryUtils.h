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
 *    (min value - world width) <= x <= (max value + world width)
 *
 * Example: For WGS84 with x values >= -180.0 and <= 180.0, provide
 * a world width of 360.0. Resulting x values will be in the range >=
 * -540.0 and <= 540.0.
 *
 * Example: For web mercator with x values >= -20037508.342789244
 * and <= 20037508.342789244, provide a world width of 40075016.685578488.
 * Resulting x values will be in the range >= -60112525.028367732 and
 * <= 60112525.028367732.
 *
 * @param geometry
 *            geometry
 * @param worldWidth
 *            world x width in geometry projection
 */
+(void) minimizeGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth;

/**
 * Normalize the geometry so all points outside of the min and max value range are
 * adjusted by the world width to fall within the range.
 *
 * Example: For WGS84 provide a world width of 360.0.
 * Resulting x values will be in the range >= -180.0 and <= 180.0.
 *
 * Example: For web mercator provide a world width of 40075016.685578488.
 * Resulting x values will be in the range >= -60112525.028367732 and <= 60112525.028367732.
 *
 * @param geometry
 *            geometry
 * @param worldWidth
 *            world x width in geometry projection
 */
+(void) normalizeGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth;

@end
