//
//  WKBGeometryUtils.m
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "WKBGeometryUtils.h"
#import "WKBGeometryCollection.h"
#import "WKBCentroidPoint.h"
#import "WKBCentroidCurve.h"
#import "WKBCentroidSurface.h"
#import "WKBMultiLineString.h"
#import "WKBMultiPolygon.h"
#import "WKBCompoundCurve.h"
#import "WKBPolyhedralSurface.h"
#import "WKBTIN.h"
#import "WKBCircularString.h"
#import "WKBTriangle.h"
#import "WKBMultiPoint.h"

@implementation WKBGeometryUtils

/**
 * Default epsilon for line tolerance
 */
static float DEFAULT_EPSILON = 0.000000000000001;

+(int) dimensionOfGeometry: (WKBGeometry *) geometry{
    
    int dimension = -1;
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
        case WKB_MULTIPOINT:
            dimension = 0;
            break;
        case WKB_LINESTRING:
        case WKB_MULTILINESTRING:
        case WKB_CIRCULARSTRING:
        case WKB_COMPOUNDCURVE:
            dimension = 1;
            break;
        case WKB_POLYGON:
        case WKB_CURVEPOLYGON:
        case WKB_MULTIPOLYGON:
        case WKB_POLYHEDRALSURFACE:
        case WKB_TIN:
        case WKB_TRIANGLE:
            dimension = 2;
            break;
        case WKB_GEOMETRYCOLLECTION:
            {
                WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
                NSArray * geometries = geomCollection.geometries;
                for (WKBGeometry * subGeometry in geometries) {
                    dimension = MAX(dimension, [self dimensionOfGeometry:subGeometry]);
                }
            }
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
    
    return dimension;
}

+(double) distanceBetweenPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2{
    double diffX = [point1.x doubleValue] - [point2.x doubleValue];
    double diffY = [point1.y doubleValue] - [point2.y doubleValue];
    
    double distance = sqrt(diffX * diffX + diffY * diffY);
    
    return distance;
}

+(WKBPoint *) centroidOfGeometry: (WKBGeometry *) geometry{
    WKBPoint * centroid = nil;
    int dimension = [self dimensionOfGeometry:geometry];
    switch (dimension) {
        case 0:
            {
                WKBCentroidPoint * point = [[WKBCentroidPoint alloc] initWithGeometry: geometry];
                centroid = [point centroid];
            }
            break;
        case 1:
            {
                WKBCentroidCurve * curve = [[WKBCentroidCurve alloc] initWithGeometry: geometry];
                centroid = [curve centroid];
            }
            break;
        case 2:
            {
                WKBCentroidSurface * surface = [[WKBCentroidSurface alloc] initWithGeometry: geometry];
                centroid = [surface centroid];
            }
            break;
    }
    return centroid;
}

+(void) minimizeGeometry: (WKBGeometry *) geometry withMaxX: (double) maxX{
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_LINESTRING:
            [self minimizeLineString:(WKBLineString *)geometry withMaxX:maxX];
            break;
        case WKB_POLYGON:
            [self minimizePolygon:(WKBPolygon *)geometry withMaxX:maxX];
            break;
        case WKB_MULTILINESTRING:
            [self minimizeMultiLineString:(WKBMultiLineString *)geometry withMaxX:maxX];
            break;
        case WKB_MULTIPOLYGON:
            [self minimizeMultiPolygon:(WKBMultiPolygon *)geometry withMaxX:maxX];
            break;
        case WKB_CIRCULARSTRING:
            [self minimizeLineString:(WKBCircularString *)geometry withMaxX:maxX];
            break;
        case WKB_COMPOUNDCURVE:
            [self minimizeCompoundCurve:(WKBCompoundCurve *)geometry withMaxX:maxX];
            break;
        case WKB_CURVEPOLYGON:
            [self minimizeCurvePolygon:(WKBCurvePolygon *)geometry withMaxX:maxX];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self minimizePolyhedralSurface:(WKBPolyhedralSurface *)geometry withMaxX:maxX];
            break;
        case WKB_TIN:
            [self minimizePolyhedralSurface:(WKBTIN *)geometry withMaxX:maxX];
            break;
        case WKB_TRIANGLE:
            [self minimizePolygon:(WKBTriangle *)geometry withMaxX:maxX];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            NSArray * geometries = geomCollection.geometries;
            for (WKBGeometry * subGeometry in geometries) {
                [self minimizeGeometry:subGeometry withMaxX:maxX];
            }
        }
            break;
        default:
            break;
            
    }
    
}

+(void) minimizeLineString: (WKBLineString *) lineString withMaxX: (double) maxX{
    
    NSMutableArray * points = lineString.points;
    if(points.count > 1){
        WKBPoint *point = [points objectAtIndex:0];
        for(int i = 1; i < points.count; i++){
            WKBPoint *nextPoint = [points objectAtIndex:i];
            if([point.x doubleValue] < [nextPoint.x doubleValue]){
                if([nextPoint.x doubleValue] - [point.x doubleValue] > [point.x doubleValue] - [nextPoint.x doubleValue] + (maxX * 2.0)){
                    [nextPoint setX:[nextPoint.x decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
                }
            }else if([point.x doubleValue] > [nextPoint.x doubleValue]){
                if([point.x doubleValue] - [nextPoint.x doubleValue] > [nextPoint.x doubleValue] - [point.x doubleValue] + (maxX * 2.0)){
                    [nextPoint setX:[nextPoint.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
                }
            }
        }
    }
}

+(void) minimizeMultiLineString: (WKBMultiLineString *) multiLineString withMaxX: (double) maxX{
    
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(WKBLineString * lineString in lineStrings){
        [self minimizeLineString:lineString withMaxX:maxX];
    }
}

+(void) minimizePolygon: (WKBPolygon *) polygon withMaxX: (double) maxX{
    
    for(WKBLineString * ring in polygon.rings){
        [self minimizeLineString:ring withMaxX:maxX];
    }
}

+(void) minimizeMultiPolygon: (WKBMultiPolygon *) multiPolygon withMaxX: (double) maxX{
    
    NSArray * polygons = [multiPolygon getPolygons];
    for(WKBPolygon * polygon in polygons){
        [self minimizePolygon:polygon withMaxX:maxX];
    }
}

+(void) minimizeCompoundCurve: (WKBCompoundCurve *) compoundCurve withMaxX: (double) maxX{
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self minimizeLineString:lineString withMaxX:maxX];
    }
}

+(void) minimizeCurvePolygon: (WKBCurvePolygon *) curvePolygon withMaxX: (double) maxX{
    
    for(WKBCurve * ring in curvePolygon.rings){
        [self minimizeGeometry:ring withMaxX:maxX];
    }
}

+(void) minimizePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withMaxX: (double) maxX{
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self minimizePolygon:polygon withMaxX:maxX];
    }
}

+(void) normalizeGeometry: (WKBGeometry *) geometry withMaxX: (double) maxX{
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            [self normalizePoint:(WKBPoint *)geometry withMaxX:maxX];
            break;
        case WKB_LINESTRING:
            [self normalizeLineString:(WKBLineString *)geometry withMaxX:maxX];
            break;
        case WKB_POLYGON:
            [self normalizePolygon:(WKBPolygon *)geometry withMaxX:maxX];
            break;
        case WKB_MULTIPOINT:
            [self normalizeMultiPoint:(WKBMultiPoint *)geometry withMaxX:maxX];
            break;
        case WKB_MULTILINESTRING:
            [self normalizeMultiLineString:(WKBMultiLineString *)geometry withMaxX:maxX];
            break;
        case WKB_MULTIPOLYGON:
            [self normalizeMultiPolygon:(WKBMultiPolygon *)geometry withMaxX:maxX];
            break;
        case WKB_CIRCULARSTRING:
            [self normalizeLineString:(WKBCircularString *)geometry withMaxX:maxX];
            break;
        case WKB_COMPOUNDCURVE:
            [self normalizeCompoundCurve:(WKBCompoundCurve *)geometry withMaxX:maxX];
            break;
        case WKB_CURVEPOLYGON:
            [self normalizeCurvePolygon:(WKBCurvePolygon *)geometry withMaxX:maxX];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self normalizePolyhedralSurface:(WKBPolyhedralSurface *)geometry withMaxX:maxX];
            break;
        case WKB_TIN:
            [self normalizePolyhedralSurface:(WKBTIN *)geometry withMaxX:maxX];
            break;
        case WKB_TRIANGLE:
            [self normalizePolygon:(WKBTriangle *)geometry withMaxX:maxX];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            NSArray * geometries = geomCollection.geometries;
            for (WKBGeometry * subGeometry in geometries) {
                [self normalizeGeometry:subGeometry withMaxX:maxX];
            }
        }
            break;
        default:
            break;
            
    }
    
}

+(void) normalizePoint: (WKBPoint *) point withMaxX: (double) maxX{
    
    if([point.x doubleValue] < -maxX){
        [point setX:[point.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
    }else if([point.x doubleValue] > maxX){
        [point setX:[point.x decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithDouble: maxX * 2.0]]];
    }
}

+(void) normalizeMultiPoint: (WKBMultiPoint *) multiPoint withMaxX: (double) maxX{
    
    NSArray * points = [multiPoint getPoints];
    for(WKBPoint * point in points){
        [self normalizePoint:point withMaxX:maxX];
    }
}

+(void) normalizeLineString: (WKBLineString *) lineString withMaxX: (double) maxX{
    
    for(WKBPoint * point in lineString.points){
        [self normalizePoint:point withMaxX:maxX];
    }
}

+(void) normalizeMultiLineString: (WKBMultiLineString *) multiLineString withMaxX: (double) maxX{
    
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(WKBLineString * lineString in lineStrings){
        [self normalizeLineString:lineString withMaxX:maxX];
    }
}

+(void) normalizePolygon: (WKBPolygon *) polygon withMaxX: (double) maxX{
    
    for(WKBLineString * ring in polygon.rings){
        [self normalizeLineString:ring withMaxX:maxX];
    }
}

+(void) normalizeMultiPolygon: (WKBMultiPolygon *) multiPolygon withMaxX: (double) maxX{
    
    NSArray * polygons = [multiPolygon getPolygons];
    for(WKBPolygon * polygon in polygons){
        [self normalizePolygon:polygon withMaxX:maxX];
    }
}

+(void) normalizeCompoundCurve: (WKBCompoundCurve *) compoundCurve withMaxX: (double) maxX{
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self normalizeLineString:lineString withMaxX:maxX];
    }
}

+(void) normalizeCurvePolygon: (WKBCurvePolygon *) curvePolygon withMaxX: (double) maxX{
    
    for(WKBCurve * ring in curvePolygon.rings){
        [self normalizeGeometry:ring withMaxX:maxX];
    }
}

+(void) normalizePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withMaxX: (double) maxX{
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self normalizePolygon:polygon withMaxX:maxX];
    }
}

+ (NSArray<WKBPoint *> *) simplifyPoints: (NSArray<WKBPoint *> *) points withTolerance : (double) tolerance{
    return [self simplifyPoints:points withTolerance:tolerance andStartIndex:0 andEndIndex:(int)[points count]-1];
}

+(NSArray<WKBPoint *> *) simplifyPoints: (NSArray<WKBPoint *> *) points withTolerance: (double) tolerance andStartIndex: (int) startIndex andEndIndex: (int) endIndex {
    
    NSArray *result = nil;
    
    double dmax = 0.0;
    int index = 0;
    
    WKBPoint *startPoint = [points objectAtIndex:startIndex];
    WKBPoint *endPoint = [points objectAtIndex:endIndex];
    
    for (int i = startIndex + 1; i < endIndex; i++) {
        WKBPoint *point = [points objectAtIndex:i];
        
        double d = [WKBGeometryUtils perpendicularDistanceBetweenPoint:point lineStart:startPoint lineEnd:endPoint];
        
        if (d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    if (dmax > tolerance) {
        
        NSArray * recResults1 = [self simplifyPoints:points withTolerance:tolerance andStartIndex:startIndex andEndIndex:index];
        NSArray * recResults2 = [self simplifyPoints:points withTolerance:tolerance andStartIndex:index andEndIndex:endIndex];
        
        result = [recResults1 subarrayWithRange:NSMakeRange(0, recResults1.count - 1)];
        result = [result arrayByAddingObjectsFromArray:recResults2];
        
    }else{
        result = [[NSArray alloc] initWithObjects:startPoint, endPoint, nil];
    }
    
    return result;
}

+(double) perpendicularDistanceBetweenPoint: (WKBPoint *) point lineStart: (WKBPoint *) lineStart lineEnd: (WKBPoint *) lineEnd {
    
    double x = [point.x doubleValue];
    double y = [point.y doubleValue];
    double startX = [lineStart.x doubleValue];
    double startY = [lineStart.y doubleValue];
    double endX = [lineEnd.x doubleValue];
    double endY = [lineEnd.y doubleValue];
    
    double vX = endX - startX;
    double vY = endY - startY;
    double wX = x - startX;
    double wY = y - startY;
    double c1 = wX * vX + wY * vY;
    double c2 = vX * vX + vY * vY;
    
    double x2;
    double y2;
    if(c1 <=0){
        x2 = startX;
        y2 = startY;
    }else if(c2 <= c1){
        x2 = endX;
        y2 = endY;
    }else{
        double b = c1 / c2;
        x2 = startX + b * vX;
        y2 = startY + b * vY;
    }
    
    double distance = sqrt(pow(x2 - x, 2) + pow(y2 - y, 2));
    
    return distance;
}

+(BOOL) point: (WKBPoint *) point inPolygon: (WKBPolygon *) polygon{
    return [self point:point inPolygon:polygon withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point inPolygon: (WKBPolygon *) polygon withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    NSArray *rings = polygon.rings;
    if(rings.count > 0){
        contains = [self point:point inPolygonRing:[rings objectAtIndex:0] withEpsilon:epsilon];
        if(contains){
            // Check the holes
            for(int i = 1; i < rings.count; i++){
                if([self point:point inPolygonRing:[rings objectAtIndex:i] withEpsilon:epsilon]){
                    contains = NO;
                    break;
                }
            }
        }
    }
    
    return contains;
}

+(BOOL) point: (WKBPoint *) point inPolygonRing: (WKBLineString *) ring{
    return [self point:point inPolygonRing:ring withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point inPolygonRing: (WKBLineString *) ring withEpsilon: (double) epsilon{
    return [self point:point inPolygonPoints:ring.points withEpsilon:epsilon];
}

+(BOOL) point: (WKBPoint *) point inPolygonPoints: (NSArray<WKBPoint *> *) points{
    return [self point:point inPolygonPoints:points withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point inPolygonPoints: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    
    int i = 0;
    int j = (int)points.count - 1;
    if([self closedPolygonPoints:points]){
        j = i++;
    }
    
    for(; i < points.count; j = i++){
        WKBPoint *point1 = [points objectAtIndex:i];
        WKBPoint *point2 = [points objectAtIndex:j];
        
        double px = [point.x doubleValue];
        double py = [point.y doubleValue];
        
        double p1x = [point1.x doubleValue];
        double p1y = [point1.y doubleValue];
        
        // Shortcut check if polygon contains the point within tolerance
        if(ABS(p1x - px) <= epsilon && ABS(p1y - py) <= epsilon){
            contains = YES;
            break;
        }
        
        double p2x = [point2.x doubleValue];
        double p2y = [point2.y doubleValue];
        
        if(((p1y > py) != (p2y > py))
           && (px < (p2x - p1x) * (py - p1y) / (p2y - p1y) + p1x)){
            contains = !contains;
        }
    }
    
    if(!contains){
        // Check the polygon edges
        contains = [self point:point onPolygonPointsEdge:points];
    }
    
    return contains;
}

+(BOOL) point: (WKBPoint *) point onPolygonEdge: (WKBPolygon *) polygon{
    return [self point:point onPolygonEdge:polygon withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onPolygonEdge: (WKBPolygon *) polygon withEpsilon: (double) epsilon{
    return [polygon numRings] > 0 && [self point:point onPolygonRingEdge:[polygon.rings objectAtIndex:0] withEpsilon:epsilon];
}

+(BOOL) point: (WKBPoint *) point onPolygonRingEdge: (WKBLineString *) ring{
    return [self point:point onPolygonRingEdge:ring withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onPolygonRingEdge: (WKBLineString *) ring withEpsilon: (double) epsilon{
    return [self point:point onPolygonPointsEdge:ring.points withEpsilon:epsilon];
}

+(BOOL) point: (WKBPoint *) point onPolygonPointsEdge: (NSArray<WKBPoint *> *) points{
    return [self point:point onPolygonPointsEdge:points withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onPolygonPointsEdge: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon{
    return [self point:point onPath:points withEpsilon:epsilon andCircular:![self closedPolygonPoints:points]];
}

+(BOOL) closedPolygon: (WKBPolygon *) polygon{
    return [polygon numRings] > 0 && [self closedPolygonRing:[polygon.rings objectAtIndex:0]];
}

+(BOOL) closedPolygonRing: (WKBLineString *) ring{
    return [self closedPolygonPoints:ring.points];
}

+(BOOL) closedPolygonPoints: (NSArray<WKBPoint *> *) points{
    BOOL closed = NO;
    if(points.count > 0){
        WKBPoint *first = [points objectAtIndex:0];
        WKBPoint *last = [points objectAtIndex:points.count - 1];
        closed = [first.x compare:last.x] == NSOrderedSame && [first.y compare:last.y] == NSOrderedSame;
    }
    return closed;
}

+(BOOL) point: (WKBPoint *) point onLine: (WKBLineString *) line{
    return [self point:point onLine:line withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onLine: (WKBLineString *) line withEpsilon: (double) epsilon{
    return [self point:point onLinePoints:line.points withEpsilon:epsilon];
}

+(BOOL) point: (WKBPoint *) point onLinePoints: (NSArray<WKBPoint *> *) points{
    return [self point:point onLinePoints:points withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onLinePoints: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon{
    return [self point:point onPath:points withEpsilon:epsilon andCircular:NO];
}

+(BOOL) point: (WKBPoint *) point onPathPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2{
    return [self point:point onPathPoint1:point1 andPoint2:point2 withEpsilon:DEFAULT_EPSILON];
}

+(BOOL) point: (WKBPoint *) point onPathPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 withEpsilon: (double) epsilon{
    
    BOOL contains = NO;
    
    double px = [point.x doubleValue];
    double py = [point.y doubleValue];
    double p1x = [point1.x doubleValue];
    double p1y = [point1.y doubleValue];
    double p2x = [point2.x doubleValue];
    double p2y = [point2.y doubleValue];
    
    double x21 = p2x - p1x;
    double y21 = p2y - p1y;
    double xP1 = px - p1x;
    double yP1 = py - p1y;
    
    double dp = xP1 * x21 + yP1 * y21;
    if(dp >= 0.0){
        
        double lengthP1 = xP1 * xP1 + yP1 * yP1;
        double length21 = x21 * x21 + y21 * y21;
        
        if(lengthP1 <= length21){
            contains = ABS(dp * dp - lengthP1 * length21) <= epsilon;
        }
    }
    
    return contains;
}

+(BOOL) point: (WKBPoint *) point onPath: (NSArray<WKBPoint *> *) points withEpsilon: (double) epsilon andCircular: (BOOL) circular{
    
    BOOL onPath = NO;
    
    int i = 0;
    int j = (int)points.count - 1;
    if(!circular){
        j = i++;
    }
    
    for(; i < points.count; j= i++){
        WKBPoint *point1 = [points objectAtIndex:i];
        WKBPoint *point2 = [points objectAtIndex:j];
        if([self point:point onPathPoint1:point1 andPoint2:point2 withEpsilon:epsilon]){
            onPath = YES;
            break;
        }
    }
    
    return onPath;
}

@end
