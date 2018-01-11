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
#import "WKBLineString.h"
#import "WKBPolygon.h"

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

/**
 * Simplify the ordered points (representing a line, polygon, etc) using the Douglas Peucker algorithm
 * to create a similar curve with fewer points. Points should be in a meters unit type projection.
 * The tolerance is the minimum tolerated distance between consecutive points.
 *
 * @param points
 *            geometry points
 * @param tolerance
 *            minimum tolerance in meters for consecutive points
 * @return simplified points
 */
+ (NSArray<WKBPoint *> *) simplifyPoints: (NSArray<WKBPoint *> *) points withTolerance : (double) tolerance;

/**
 * Calculate the perpendicular distance between the point and the line represented by the start and end points.
 * Points should be in a meters unit type projection.
 *
 * @param point
 *            point
 * @param lineStart
 *            point representing the line start
 * @param lineEnd
 *            point representing the line end
 * @return distance in meters
 */
+ (double) perpendicularDistanceBetweenPoint: (WKBPoint *) point lineStart: (WKBPoint *) lineStart lineEnd: (WKBPoint *) lineEnd;

/**
 * Check if the point is in the polygon
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygon: (WKBPolygon *) polygon;

/**
 * Check if the point is in the polygon
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygon: (WKBPolygon *) polygon withEpsilon: (double) epsilon;

/**
 * Check if the point is in the polygon ring
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygonRing: (WKBLineString *) ring;

/**
 * Check if the point is in the polygon ring
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygonRing: (WKBLineString *) ring withEpsilon: (double) epsilon;

/**
 * Check if the point is in the polygon points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygonPoints: (NSArray<WKBPoint *> *) points;

/**
 * Check if the point is in the polygon points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if in the polygon
 */
+(BOOL) point: (WKBPoint *) point inPolygonPoints: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon edge
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonEdge: (WKBPolygon *) polygon;

/**
 * Check if the point is on the polygon edge
 *
 * @param point
 *            point
 * @param polygon
 *            polygon
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonEdge: (WKBPolygon *) polygon withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon ring edge
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonRingEdge: (WKBLineString *) ring;

/**
 * Check if the point is on the polygon ring edge
 *
 * @param point
 *            point
 * @param ring
 *            polygon ring
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonRingEdge: (WKBLineString *) ring withEpsilon: (double) epsilon;

/**
 * Check if the point is on the polygon ring edge points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonPointsEdge: (NSArray<WKBPoint *> *) points;

/**
 * Check if the point is on the polygon ring edge points
 *
 * @param point
 *            point
 * @param points
 *            polygon points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the polygon edge
 */
+(BOOL) point: (WKBPoint *) point onPolygonPointsEdge: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the polygon outer ring is explicitly closed, where the first and
 * last point are the same
 *
 * @param polygon
 *            polygon
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygon: (WKBPolygon *) polygon;

/**
 * Check if the polygon ring is explicitly closed, where the first and last
 * point are the same
 *
 * @param ring
 *            polygon ring
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygonRing: (WKBLineString *) ring;

/**
 * Check if the polygon ring points are explicitly closed, where the first
 * and last point are the same
 *
 * @param points
 *            polygon ring points
 * @return true if the first and last points are the same
 */
+(BOOL) closedPolygonPoints: (NSArray<WKBPoint *> *) points;

/**
 * Check if the point is on the line
 *
 * @param point
 *            point
 * @param line
 *            line
 * @return true if on the line
 */
+(BOOL) point: (WKBPoint *) point onLine: (WKBLineString *) line;

/**
 * Check if the point is on the line
 *
 * @param point
 *            point
 * @param line
 *            line
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the line
 */
+(BOOL) point: (WKBPoint *) point onLine: (WKBLineString *) line withEpsilon: (double) epsilon;

/**
 * Check if the point is on the line represented by the points
 *
 * @param point
 *            point
 * @param points
 *            line points
 * @return true if on the line
 */
+(BOOL) point: (WKBPoint *) point onLinePoints: (NSArray<WKBPoint *> *) points;

/**
 * Check if the point is on the line represented by the points
 *
 * @param point
 *            point
 * @param points
 *            line points
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the line
 */
+(BOOL) point: (WKBPoint *) point onLinePoints: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon;

/**
 * Check if the point is on the path between point 1 and point 2
 *
 * @param point
 *            point
 * @param point1
 *            path point 1
 * @param point2
 *            path point 2
 * @return true if on the path
 */
+(BOOL) point: (WKBPoint *) point onPathPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2;

/**
 * Check if the point is on the path between point 1 and point 2
 *
 * @param point
 *            point
 * @param point1
 *            path point 1
 * @param point2
 *            path point 2
 * @param epsilon
 *            epsilon line tolerance
 * @return true if on the path
 */
+(BOOL) point: (WKBPoint *) point onPathPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 withEpsilon: (double) epsilon;

@end
