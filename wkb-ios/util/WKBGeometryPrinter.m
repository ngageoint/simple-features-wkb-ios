//
//  WKBGeometryPrinter.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryPrinter.h"
#import "WKBGeometry.h"
#import "WKBPoint.h"
#import "WKBLineString.h"
#import "WKBPolygon.h"
#import "WKBMultiPoint.h"
#import "WKBMultiLineString.h"
#import "WKBMultiPolygon.h"
#import "WKBGeometryCollection.h"
#import "WKBCircularString.h"
#import "WKBCompoundCurve.h"
#import "WKBCurvePolygon.h"
#import "WKBPolyhedralSurface.h"
#import "WKBTIN.h"
#import "WKBTriangle.h"

@implementation WKBGeometryPrinter

+(NSString *) getGeometryString: (WKBGeometry *) geometry{
    
    NSMutableString * message = [[NSMutableString alloc]init];
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            [self addPoint:(WKBPoint *)geometry toMessage:message];
            break;
        case WKB_LINESTRING:
            [self addLineString:(WKBLineString *)geometry toMessage:message];
            break;
        case WKB_POLYGON:
            [self addPolygon:(WKBPolygon *)geometry toMessage:message];
            break;
        case WKB_MULTIPOINT:
            [self addMultiPoint:(WKBMultiPoint *)geometry toMessage:message];
            break;
        case WKB_MULTILINESTRING:
            [self addMultiLineString:(WKBMultiLineString *)geometry toMessage:message];
            break;
        case WKB_MULTIPOLYGON:
            [self addMultiPolygon:(WKBMultiPolygon *)geometry toMessage:message];
            break;
        case WKB_CIRCULARSTRING:
            [self addLineString:(WKBCircularString *)geometry toMessage:message];
            break;
        case WKB_COMPOUNDCURVE:
            [self addCompoundCurve:(WKBCompoundCurve *)geometry toMessage:message];
            break;
        case WKB_CURVEPOLYGON:
            [self addCurvePolygon:(WKBCurvePolygon *)geometry toMessage:message];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self addPolyhedralSurface:(WKBPolyhedralSurface *)geometry toMessage:message];
            break;
        case WKB_TIN:
            [self addPolyhedralSurface:(WKBTIN *)geometry toMessage:message];
            break;
        case WKB_TRIANGLE:
            [self addPolygon:(WKBTriangle *)geometry toMessage:message];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            [message appendFormat:@"Geometries: %@", [geomCollection numGeometries]];
            NSArray * geometries = geomCollection.geometries;
            for(int i = 0; i < geometries.count; i++){
                WKBGeometry * subGeometry = [geometries objectAtIndex:i];
                [message appendString:@"\n\n"];
                [message appendFormat:@"Geometry %d", (i+1)];
                [message appendString:@"\n"];
                [message appendFormat:@"%@", [WKBGeometryTypes name:subGeometry.geometryType]];
                [message appendString:@"\n"];
                [message appendString:[self getGeometryString:subGeometry]];
            }
        }
            break;
        default:
            break;
            
    }
    
    return message;
}

+(void) addPoint: (WKBPoint *) point toMessage: (NSMutableString *) message{
    [message appendFormat:@"Latitude: %@", point.y];
    [message appendFormat:@"\nLongitude: %@", point.x];
}

+(void) addMultiPoint: (WKBMultiPoint *) multiPoint toMessage: (NSMutableString *) message{
    [message appendFormat:@"Points: %@", [multiPoint numPoints]];
    NSArray * points = [multiPoint getPoints];
    for(int i = 0; i < points.count; i++){
        WKBPoint * point = [points objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Point %d", (i+1)];
        [message appendString:@"\n"];
        [self addPoint:point toMessage:message];
    }
}

+(void) addLineString: (WKBLineString *) lineString toMessage: (NSMutableString *) message{
    [message appendFormat:@"Points: %@", [lineString numPoints]];
    for(WKBPoint * point in lineString.points){
        [message appendString:@"\n\n"];
        [self addPoint:point toMessage:message];
    }
}

+(void) addMultiLineString: (WKBMultiLineString *) multiLineString toMessage: (NSMutableString *) message{
    [message appendFormat:@"LineStrings: %@", [multiLineString numLineStrings]];
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(int i = 0; i < lineStrings.count; i++){
        WKBLineString * lineString = [lineStrings objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"LineString %d", (i+1)];
        [message appendString:@"\n"];
        [self addLineString:lineString toMessage:message];
    }
}

+(void) addPolygon: (WKBPolygon *) polygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Rings: %@", [polygon numRings]];
    for(int i = 0; i < polygon.rings.count; i++){
        WKBLineString * ring = [polygon.rings objectAtIndex:i];
        [message appendString:@"\n\n"];
        if(i > 0){
            [message appendFormat:@"Hole %d", i];
            [message appendString:@"\n"];
        }
        [self addLineString:ring toMessage:message];
    }
}

+(void) addMultiPolygon: (WKBMultiPolygon *) multiPolygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Polygons: %@", [multiPolygon numPolygons]];
    NSArray * polygons = [multiPolygon getPolygons];
    for(int i = 0; i < polygons.count; i++){
        WKBPolygon * polygon = [polygons objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Polygon %d", (i+1)];
        [message appendString:@"\n"];
        [self addPolygon:polygon toMessage:message];
    }
}

+(void) addCompoundCurve: (WKBCompoundCurve *) compoundCurve toMessage: (NSMutableString *) message{
    [message appendFormat:@"LineStrings: %@", [compoundCurve numLineStrings]];
    for(int i = 0; i < compoundCurve.lineStrings.count; i++){
        WKBLineString * lineString = [compoundCurve.lineStrings objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"LineString %d", (i+1)];
        [message appendString:@"\n"];
        [self addLineString:lineString toMessage:message];
    }
}

+(void) addCurvePolygon: (WKBCurvePolygon *) curvePolygon toMessage: (NSMutableString *) message{
    [message appendFormat:@"Rings: %@", [curvePolygon numRings]];
    for(int i = 0; i < curvePolygon.rings.count; i++){
        WKBCurve * ring = [curvePolygon.rings objectAtIndex:i];
        [message appendString:@"\n\n"];
        if(i > 0){
            [message appendFormat:@"Hole %d", i];
            [message appendString:@"\n"];
        }
        [message appendString:[self getGeometryString:ring]];
    }
}

+(void) addPolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface toMessage: (NSMutableString *) message{
    [message appendFormat:@"Polygons: %@", [polyhedralSurface numPolygons]];
    for(int i = 0; i < polyhedralSurface.polygons.count; i++){
        WKBPolygon * polygon = [polyhedralSurface.polygons objectAtIndex:i];
        [message appendString:@"\n\n"];
        [message appendFormat:@"Polygon %d", (i+1)];
        [message appendString:@"\n"];
        [self addPolygon:polygon toMessage:message];
    }
}

@end
