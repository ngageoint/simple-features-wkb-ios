//
//  WKBGeometryWriter.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryWriter.h"

@implementation WKBGeometryWriter

+(void) writeGeometry: (WKBGeometry *) geometry withWriter: (WKBByteWriter *) writer{

    // Write the single byte order byte
    uint8_t byteOrderInt = -1;
    if(writer.byteOrder == CFByteOrderBigEndian){
        byteOrderInt = 0;
    }else if(writer.byteOrder == CFByteOrderLittleEndian){
        byteOrderInt = 1;
    }else{
        [NSException raise:@"Unexpected Byte Order" format:@"Unexpected byte order: %ld", writer.byteOrder];
    }
    NSNumber * byteOrder = [NSNumber numberWithInt:byteOrderInt];
    [writer writeByte:byteOrder];
    
    // Write the geometry type integer
    [writer writeInt:[NSNumber numberWithInt:[geometry getWkbCode]]];
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    
    switch (geometryType) {
            
        case WKB_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_POINT:
            [self writePoint:(WKBPoint *)geometry withWriter:writer];
            break;
        case WKB_LINESTRING:
            [self writeLineString:(WKBLineString *)geometry withWriter:writer];
            break;
        case WKB_POLYGON:
            [self writePolygon:(WKBPolygon *)geometry withWriter:writer];
            break;
        case WKB_MULTIPOINT:
            [self writeMultiPoint:(WKBMultiPoint *)geometry withWriter:writer];
            break;
        case WKB_MULTILINESTRING:
            [self writeMultiLineString:(WKBMultiLineString *)geometry withWriter:writer];
            break;
        case WKB_MULTIPOLYGON:
            [self writeMultiPolygon:(WKBMultiPolygon *)geometry withWriter:writer];
            break;
        case WKB_GEOMETRYCOLLECTION:
            [self writeGeometryCollection:(WKBGeometryCollection *)geometry withWriter:writer];
            break;
        case WKB_CIRCULARSTRING:
            [self writeCircularString:(WKBCircularString *)geometry withWriter:writer];
            break;
        case WKB_COMPOUNDCURVE:
            [self writeCompoundCurve:(WKBCompoundCurve *)geometry withWriter:writer];
            break;
        case WKB_CURVEPOLYGON:
            [self writeCurvePolygon:(WKBCurvePolygon *)geometry withWriter:writer];
            break;
        case WKB_MULTICURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_MULTISURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_POLYHEDRALSURFACE:
            [self writePolyhedralSurface:(WKBPolyhedralSurface *)geometry withWriter:writer];
            break;
        case WKB_TIN:
            [self writeTIN:(WKBTIN *)geometry withWriter:writer];
            break;
        case WKB_TRIANGLE:
            [self writeTriangle:(WKBTriangle *)geometry withWriter:writer];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
}

+(void) writePoint: (WKBPoint *) point withWriter: (WKBByteWriter *) writer{
    
    [writer writeDouble:point.x];
    [writer writeDouble:point.y];
    
    if(point.hasZ){
        [writer writeDouble:point.z];
    }
    
    if(point.hasM){
        [writer writeDouble:point.m];
    }
}

+(void) writeLineString: (WKBLineString *) lineString withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[lineString numPoints]];
    
    for(WKBPoint * point in lineString.points){
        [self writePoint:point withWriter:writer];
    }
}

+(void) writePolygon: (WKBPolygon *) polygon withWriter: (WKBByteWriter *) writer{

    [writer writeInt:[polygon numRings]];
    
    for(WKBLineString * lineString in polygon.rings){
        [self writeLineString:lineString withWriter:writer];
    }
}

+(void) writeMultiPoint: (WKBMultiPoint *) multiPoint withWriter: (WKBByteWriter *) writer{

    [writer writeInt:[multiPoint numPoints]];
    
    for(WKBPoint * point in [multiPoint getPoints]){
        [self writeGeometry:point withWriter:writer];
    }
}

+(void) writeMultiLineString: (WKBMultiLineString *) multiLineString withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[multiLineString numLineStrings]];
    
    for(WKBLineString * lineString in [multiLineString getLineStrings]){
        [self writeGeometry:lineString withWriter:writer];
    }
}

+(void) writeMultiPolygon: (WKBMultiPolygon *) multiPolygon withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[multiPolygon numPolygons]];
    
    for(WKBPolygon * polygon in [multiPolygon getPolygons]){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeGeometryCollection: (WKBGeometryCollection *) geometryCollection withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[geometryCollection numGeometries]];
    
    for(WKBGeometry * geometry in geometryCollection.geometries){
        [self writeGeometry:geometry withWriter:writer];
    }
}

+(void) writeCircularString: (WKBCircularString *) circularString withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[circularString numPoints]];
    
    for(WKBPoint * point in circularString.points){
        [self writePoint:point withWriter:writer];
    }
}

+(void) writeCompoundCurve: (WKBCompoundCurve *) compoundCurve withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[compoundCurve numLineStrings]];
    
    for(WKBLineString * lineString in compoundCurve.lineStrings){
        [self writeGeometry:lineString withWriter:writer];
    }
}

+(void) writeCurvePolygon: (WKBCurvePolygon *) curvePolygon withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[curvePolygon numRings]];
    
    for(WKBCurve * ring in curvePolygon.rings){
        [self writeGeometry:ring withWriter:writer];
    }
}

+(void) writePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[polyhedralSurface numPolygons]];
    
    for(WKBPolygon * polygon in polyhedralSurface.polygons){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeTIN: (WKBTIN *) tin withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[tin numPolygons]];
    
    for(WKBPolygon * polygon in tin.polygons){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeTriangle: (WKBTriangle *) triangle withWriter: (WKBByteWriter *) writer{
    
    [writer writeInt:[triangle numRings]];
    
    for(WKBLineString * ring in triangle.rings){
        [self writeLineString:ring withWriter:writer];
    }
}

@end
