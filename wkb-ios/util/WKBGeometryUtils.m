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

+(void) normalizePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withMaxX: (double) maxX{
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self normalizePolygon:polygon withMaxX:maxX];
    }
}

@end
