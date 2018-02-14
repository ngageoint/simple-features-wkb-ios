//
//  WKBGeometryEnvelopeBuilder.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryEnvelopeBuilder.h"
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

@implementation WKBGeometryEnvelopeBuilder

+(WKBGeometryEnvelope *) buildEnvelopeWithGeometry: (WKBGeometry *) geometry{
    
    WKBGeometryEnvelope * envelope = [[WKBGeometryEnvelope alloc] init];
    
    [self buildEnvelope:envelope andGeometry:geometry];
    
    return envelope;
}

+(void) buildEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry{
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            [self addPoint:(WKBPoint *)geometry andEnvelope:envelope];
            break;
        case WKB_LINESTRING:
            [self addLineString:(WKBLineString *)geometry andEnvelope:envelope];
            break;
        case WKB_POLYGON:
            [self addPolygon:(WKBPolygon *)geometry andEnvelope:envelope];
            break;
        case WKB_MULTIPOINT:
            [self addMultiPoint:(WKBMultiPoint *)geometry andEnvelope:envelope];
            break;
        case WKB_MULTILINESTRING:
            [self addMultiLineString:(WKBMultiLineString *)geometry andEnvelope:envelope];
            break;
        case WKB_MULTIPOLYGON:
            [self addMultiPolygon:(WKBMultiPolygon *)geometry andEnvelope:envelope];
            break;
        case WKB_CIRCULARSTRING:
            [self addLineString:(WKBCircularString *)geometry andEnvelope:envelope];
            break;
        case WKB_COMPOUNDCURVE:
            [self addCompoundCurve:(WKBCompoundCurve *)geometry andEnvelope:envelope];
            break;
        case WKB_CURVEPOLYGON:
            [self addCurvePolygon:(WKBCurvePolygon *)geometry andEnvelope:envelope];
            break;
        case WKB_POLYHEDRALSURFACE:
            [self addPolyhedralSurface:(WKBPolyhedralSurface *)geometry andEnvelope:envelope];
            break;
        case WKB_TIN:
            [self addPolyhedralSurface:(WKBTIN *)geometry andEnvelope:envelope];
            break;
        case WKB_TRIANGLE:
            [self addPolygon:(WKBTriangle *)geometry andEnvelope:envelope];
            break;
        case WKB_GEOMETRYCOLLECTION:
            {
                [self updateHasZandMWithEnvelope:envelope andGeometry:geometry];
                WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
                NSArray * geometries = geomCollection.geometries;
                for (WKBGeometry * subGeometry in geometries) {
                    [self buildEnvelope:envelope andGeometry:subGeometry];
                }
            }
            break;
        default:
            break;
            
    }
    
}

+(void) updateHasZandMWithEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry{
    if(!envelope.hasZ && geometry.hasZ){
        [envelope setHasZ:true];
    }
    if(!envelope.hasM && geometry.hasM){
        [envelope setHasM:true];
    }
}

+(void) addPoint: (WKBPoint *) point andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:point];
    
    NSDecimalNumber * x = point.x;
    NSDecimalNumber * y = point.y;
    if(envelope.minX == nil || [x compare:envelope.minX] == NSOrderedAscending){
        [envelope setMinX:x];
    }
    if(envelope.maxX == nil || [x compare:envelope.maxX] == NSOrderedDescending){
        [envelope setMaxX:x];
    }
    if(envelope.minY == nil || [y compare:envelope.minY] == NSOrderedAscending){
        [envelope setMinY:y];
    }
    if(envelope.maxY == nil || [y compare:envelope.maxY] == NSOrderedDescending){
        [envelope setMaxY:y];
    }
    if (point.hasZ) {
        NSDecimalNumber * z = point.z;
        if (z != nil) {
            if (envelope.minZ == nil || [z compare:envelope.minZ] == NSOrderedAscending) {
                [envelope setMinZ:z];
            }
            if (envelope.maxZ == nil || [z compare:envelope.maxZ] == NSOrderedDescending) {
                [envelope setMaxZ:z];
            }
        }
    }
    if (point.hasM) {
        NSDecimalNumber * m = point.m;
        if (m != nil) {
            if (envelope.minM == nil || [m compare:envelope.minM] == NSOrderedAscending) {
                [envelope setMinM:m];
            }
            if (envelope.maxM == nil || [m compare:envelope.maxM] == NSOrderedDescending) {
                [envelope setMaxM:m];
            }
        }
    }
}

+(void) addMultiPoint: (WKBMultiPoint *) multiPoint andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiPoint];
    
    NSArray * points = [multiPoint getPoints];
    for(WKBPoint * point in points){
        [self addPoint:point andEnvelope:envelope];
    }
}

+(void) addLineString: (WKBLineString *) lineString andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:lineString];
    
    for(WKBPoint * point in lineString.points){
        [self addPoint:point andEnvelope:envelope];
    }
}

+(void) addMultiLineString: (WKBMultiLineString *) multiLineString andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiLineString];
    
    NSArray * lineStrings = [multiLineString getLineStrings];
    for(WKBLineString * lineString in lineStrings){
        [self addLineString:lineString andEnvelope:envelope];
    }
}

+(void) addPolygon: (WKBPolygon *) polygon andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:polygon];
    
    for(WKBLineString * ring in polygon.rings){
        [self addLineString:ring andEnvelope:envelope];
    }
}

+(void) addMultiPolygon: (WKBMultiPolygon *) multiPolygon andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:multiPolygon];
    
    NSArray * polygons = [multiPolygon getPolygons];
    for(WKBPolygon * polygon in polygons){
        [self addPolygon:polygon andEnvelope:envelope];
    }
}

+(void) addCompoundCurve: (WKBCompoundCurve *) compoundCurve andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:compoundCurve];
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self addLineString:lineString andEnvelope:envelope];
    }
}

+(void) addCurvePolygon: (WKBCurvePolygon *) curvePolygon andEnvelope: (WKBGeometryEnvelope *) envelope{
 
    [self updateHasZandMWithEnvelope:envelope andGeometry:curvePolygon];
    
    for(WKBCurve * ring in curvePolygon.rings){
        [self buildEnvelope:envelope andGeometry:ring];
    }
}

+(void) addPolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface andEnvelope: (WKBGeometryEnvelope *) envelope{
    
    [self updateHasZandMWithEnvelope:envelope andGeometry:polyhedralSurface];
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self addPolygon:polygon andEnvelope:envelope];
    }
}

@end
