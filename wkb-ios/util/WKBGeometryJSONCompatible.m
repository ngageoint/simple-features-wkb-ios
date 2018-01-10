//
//  WKBGeometryJSONCompatible.m
//  wkb-ios
//
//  Created by Brian Osborn on 3/16/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import "WKBGeometryJSONCompatible.h"
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

@implementation WKBGeometryJSONCompatible

+(NSObject *) getJSONCompatibleGeometry: (WKBGeometry *) geometry{
    
    NSMutableDictionary * jsonObject = [[NSMutableDictionary alloc] init];
    
    NSObject * geometryObject = [self getJSONCompatibleGeometryObject:geometry];
    
    if(geometryObject != nil){
        [jsonObject setObject:geometryObject forKey:[WKBGeometryTypes name:geometry.geometryType]];
    }
    
    return jsonObject;
}

+(NSObject *) getJSONCompatibleGeometryObject: (WKBGeometry *) geometry{
    
    NSObject * geometryObject = nil;
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            geometryObject = [self getPoint:(WKBPoint *)geometry];
            break;
        case WKB_LINESTRING:
            geometryObject = [self getLineString:(WKBLineString *)geometry];
            break;
        case WKB_POLYGON:
            geometryObject = [self getPolygon:(WKBPolygon *)geometry];
            break;
        case WKB_MULTIPOINT:
            geometryObject = [self getMultiPoint:(WKBMultiPoint *)geometry];
            break;
        case WKB_MULTILINESTRING:
            geometryObject = [self getMultiLineString:(WKBMultiLineString *)geometry];
            break;
        case WKB_MULTIPOLYGON:
            geometryObject = [self getMultiPolygon:(WKBMultiPolygon *)geometry];
            break;
        case WKB_CIRCULARSTRING:
            geometryObject = [self getLineString:(WKBCircularString *)geometry];
            break;
        case WKB_COMPOUNDCURVE:
            geometryObject = [self getCompoundCurve:(WKBCompoundCurve *)geometry];
            break;
        case WKB_CURVEPOLYGON:
            geometryObject = [self getCurvePolygon:(WKBCurvePolygon *)geometry];
            break;
        case WKB_POLYHEDRALSURFACE:
            geometryObject = [self getPolyhedralSurface:(WKBPolyhedralSurface *)geometry];
            break;
        case WKB_TIN:
            geometryObject = [self getPolyhedralSurface:(WKBTIN *)geometry];
            break;
        case WKB_TRIANGLE:
            geometryObject = [self getPolygon:(WKBTriangle *)geometry];
            break;
        case WKB_GEOMETRYCOLLECTION:
        {
            NSMutableArray * jsonGeoCollectionObject = [[NSMutableArray alloc] init];
            WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
            NSArray * geometries = geomCollection.geometries;
            for(int i = 0; i < geometries.count; i++){
                WKBGeometry * subGeometry = [geometries objectAtIndex:i];
                [jsonGeoCollectionObject addObject:[self getJSONCompatibleGeometry:subGeometry]];
            }
            geometryObject = jsonGeoCollectionObject;
        }
            break;
        default:
            break;
    }
    
    return geometryObject;
}

+(NSObject *) getPoint: (WKBPoint *) point{
    NSMutableDictionary * jsonObject = [[NSMutableDictionary alloc] init];
    [jsonObject setObject:point.x forKey:@"x"];
    [jsonObject setObject:point.y forKey:@"y"];
    if([point hasZ]){
        [jsonObject setObject:point.z forKey:@"z"];
    }
    if([point hasM]){
        [jsonObject setObject:point.m forKey:@"m"];
    }
    return jsonObject;
}

+(NSObject *) getMultiPoint: (WKBMultiPoint *) multiPoint{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    NSArray * points = [multiPoint getPoints];
    for(int i = 0; i < points.count; i++){
        WKBPoint * point = [points objectAtIndex:i];
        [jsonObject addObject:[self getPoint:point]];
    }
    return jsonObject;
}

+(NSObject *) getLineString: (WKBLineString *) lineString{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    for(WKBPoint * point in lineString.points){
        [jsonObject addObject:[self getPoint:point]];
    }
    return jsonObject;
}

+(NSObject *) getMultiLineString: (WKBMultiLineString *) multiLineString{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(int i = 0; i < lineStrings.count; i++){
        WKBLineString * lineString = [lineStrings objectAtIndex:i];
        [jsonObject addObject:[self getLineString:lineString]];
    }
    return jsonObject;
}

+(NSObject *) getPolygon: (WKBPolygon *) polygon{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    for(int i = 0; i < polygon.rings.count; i++){
        WKBLineString * ring = [polygon.rings objectAtIndex:i];
        [jsonObject addObject:[self getLineString:ring]];
    }
    return jsonObject;
}

+(NSObject *) getMultiPolygon: (WKBMultiPolygon *) multiPolygon{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    NSArray * polygons = [multiPolygon getPolygons];
    for(int i = 0; i < polygons.count; i++){
        WKBPolygon * polygon = [polygons objectAtIndex:i];
        [jsonObject addObject:[self getPolygon:polygon]];
    }
    return jsonObject;
}

+(NSObject *) getCompoundCurve: (WKBCompoundCurve *) compoundCurve{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    for(int i = 0; i < compoundCurve.lineStrings.count; i++){
        WKBLineString * lineString = [compoundCurve.lineStrings objectAtIndex:i];
        [jsonObject addObject:[self getLineString:lineString]];
    }
    return jsonObject;
}

+(NSObject *) getCurvePolygon: (WKBCurvePolygon *) curvePolygon{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    for(int i = 0; i < curvePolygon.rings.count; i++){
        WKBCurve * ring = [curvePolygon.rings objectAtIndex:i];
        [jsonObject addObject:[self getJSONCompatibleGeometryObject:ring]];
    }
    return jsonObject;
}

+(NSObject *) getPolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface{
    NSMutableArray * jsonObject = [[NSMutableArray alloc] init];
    for(int i = 0; i < polyhedralSurface.polygons.count; i++){
        WKBPolygon * polygon = [polyhedralSurface.polygons objectAtIndex:i];
        [jsonObject addObject:[self getPolygon:polygon]];
    }
    return jsonObject;
}

@end
