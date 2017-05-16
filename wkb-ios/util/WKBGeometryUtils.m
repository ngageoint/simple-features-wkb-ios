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
#import "WKBLineString.h"
#import "WKBMultiLineString.h"
#import "WKBPolygon.h"
#import "WKBMultiPolygon.h"
#import "WKBCompoundCurve.h"
#import "WKBPolyhedralSurface.h"
#import "WKBTIN.h"
#import "WKBCircularString.h"
#import "WKBTriangle.h"
#import "WKBMultiPoint.h"

@implementation WKBGeometryUtils

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

+(void) minimizeGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth{
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_LINESTRING:
            [self minimizeLineString:(WKBLineString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_POLYGON:
            [self minimizePolygon:(WKBPolygon *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_MULTILINESTRING:
            [self minimizeMultiLineString:(WKBMultiLineString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_MULTIPOLYGON:
            [self minimizeMultiPolygon:(WKBMultiPolygon *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_CIRCULARSTRING:
            [self minimizeLineString:(WKBCircularString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_COMPOUNDCURVE:
            [self minimizeCompoundCurve:(WKBCompoundCurve *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self minimizePolyhedralSurface:(WKBPolyhedralSurface *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_TIN:
            [self minimizePolyhedralSurface:(WKBTIN *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_TRIANGLE:
            [self minimizePolygon:(WKBTriangle *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            NSArray * geometries = geomCollection.geometries;
            for (WKBGeometry * subGeometry in geometries) {
                [self minimizeGeometry:subGeometry withWorldWidth:worldWidth];
            }
        }
            break;
        default:
            break;
            
    }
    
}

+(void) minimizeLineString: (WKBLineString *) lineString withWorldWidth: (double) worldWidth{
    
    NSMutableArray * points = lineString.points;
    if(points.count > 1){
        WKBPoint *point = [points objectAtIndex:0];
        for(int i = 1; i < points.count; i++){
            WKBPoint *nextPoint = [points objectAtIndex:i];
            if([point.x doubleValue] < [nextPoint.x doubleValue]){
                if([nextPoint.x doubleValue] - [point.x doubleValue] > [point.x doubleValue] - [nextPoint.x doubleValue] + worldWidth){
                    [nextPoint setX:[nextPoint.x decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithDouble: worldWidth]]];
                }
            }else if([point.x doubleValue] > [nextPoint.x doubleValue]){
                if([point.x doubleValue] - [nextPoint.x doubleValue] > [nextPoint.x doubleValue] - [point.x doubleValue] + worldWidth){
                    [nextPoint setX:[nextPoint.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble: worldWidth]]];
                }
            }
        }
    }
}

+(void) minimizeMultiLineString: (WKBMultiLineString *) multiLineString withWorldWidth: (double) worldWidth{
    
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(WKBLineString * lineString in lineStrings){
        [self minimizeLineString:lineString withWorldWidth:worldWidth];
    }
}

+(void) minimizePolygon: (WKBPolygon *) polygon withWorldWidth: (double) worldWidth{
    
    for(WKBLineString * ring in polygon.rings){
        [self minimizeLineString:ring withWorldWidth:worldWidth];
    }
}

+(void) minimizeMultiPolygon: (WKBMultiPolygon *) multiPolygon withWorldWidth: (double) worldWidth{
    
    NSArray * polygons = [multiPolygon getPolygons];
    for(WKBPolygon * polygon in polygons){
        [self minimizePolygon:polygon withWorldWidth:worldWidth];
    }
}

+(void) minimizeCompoundCurve: (WKBCompoundCurve *) compoundCurve withWorldWidth: (double) worldWidth{
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self minimizeLineString:lineString withWorldWidth:worldWidth];
    }
}

+(void) minimizePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withWorldWidth: (double) worldWidth{
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self minimizePolygon:polygon withWorldWidth:worldWidth];
    }
}

+(void) normalizeGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth{
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            [self normalizePoint:(WKBPoint *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_LINESTRING:
            [self normalizeLineString:(WKBLineString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_POLYGON:
            [self normalizePolygon:(WKBPolygon *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_MULTIPOINT:
            [self normalizeMultiPoint:(WKBMultiPoint *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_MULTILINESTRING:
            [self normalizeMultiLineString:(WKBMultiLineString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_MULTIPOLYGON:
            [self normalizeMultiPolygon:(WKBMultiPolygon *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_CIRCULARSTRING:
            [self normalizeLineString:(WKBCircularString *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_COMPOUNDCURVE:
            [self normalizeCompoundCurve:(WKBCompoundCurve *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self normalizePolyhedralSurface:(WKBPolyhedralSurface *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_TIN:
            [self normalizePolyhedralSurface:(WKBTIN *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_TRIANGLE:
            [self normalizePolygon:(WKBTriangle *)geometry withWorldWidth:worldWidth];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            NSArray * geometries = geomCollection.geometries;
            for (WKBGeometry * subGeometry in geometries) {
                [self normalizeGeometry:subGeometry withWorldWidth:worldWidth];
            }
        }
            break;
        default:
            break;
            
    }
    
}

+(void) normalizePoint: (WKBPoint *) point withWorldWidth: (double) worldWidth{
    
    double halfWorldWith = worldWidth / 2.0;
    if([point.x doubleValue] < -halfWorldWith){
        [point setX:[point.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble: worldWidth]]];
    }else if([point.x doubleValue] > halfWorldWith){
        [point setX:[point.x decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithDouble: worldWidth]]];
    }
}

+(void) normalizeMultiPoint: (WKBMultiPoint *) multiPoint withWorldWidth: (double) worldWidth{
    
    NSArray * points = [multiPoint getPoints];
    for(WKBPoint * point in points){
        [self normalizePoint:point withWorldWidth:worldWidth];
    }
}

+(void) normalizeLineString: (WKBLineString *) lineString withWorldWidth: (double) worldWidth{
    
    for(WKBPoint * point in lineString.points){
        [self normalizePoint:point withWorldWidth:worldWidth];
    }
}

+(void) normalizeMultiLineString: (WKBMultiLineString *) multiLineString withWorldWidth: (double) worldWidth{
    
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(WKBLineString * lineString in lineStrings){
        [self normalizeLineString:lineString withWorldWidth:worldWidth];
    }
}

+(void) normalizePolygon: (WKBPolygon *) polygon withWorldWidth: (double) worldWidth{
    
    for(WKBLineString * ring in polygon.rings){
        [self normalizeLineString:ring withWorldWidth:worldWidth];
    }
}

+(void) normalizeMultiPolygon: (WKBMultiPolygon *) multiPolygon withWorldWidth: (double) worldWidth{
    
    NSArray * polygons = [multiPolygon getPolygons];
    for(WKBPolygon * polygon in polygons){
        [self normalizePolygon:polygon withWorldWidth:worldWidth];
    }
}

+(void) normalizeCompoundCurve: (WKBCompoundCurve *) compoundCurve withWorldWidth: (double) worldWidth{
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self normalizeLineString:lineString withWorldWidth:worldWidth];
    }
}

+(void) normalizePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withWorldWidth: (double) worldWidth{
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self normalizePolygon:polygon withWorldWidth:worldWidth];
    }
}

@end
