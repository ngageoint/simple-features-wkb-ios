//
//  SFWBGeometryWriter.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFWBGeometryWriter.h"
#import "SFWBGeometryCodes.h"

@implementation SFWBGeometryWriter

+(NSData *) writeGeometry: (SFGeometry *) geometry{
    return [self writeGeometry:geometry inByteOrder:DEFAULT_WRITE_BYTE_ORDER];
}

+(NSData *) writeGeometry: (SFGeometry *) geometry inByteOrder: (CFByteOrder) byteOrder{
    NSData *data = nil;
    SFByteWriter *writer = [[SFByteWriter alloc] initWithByteOrder:byteOrder];
    @try {
        [self writeGeometry:geometry withWriter:writer];
        data = [writer data];
    } @finally {
        [writer close];
    }
    return data;
}

+(void) writeGeometry: (SFGeometry *) geometry withWriter: (SFByteWriter *) writer{

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
    [self writeInt:[SFWBGeometryCodes codeFromGeometry:geometry] withWriter:writer];
    
    enum SFGeometryType geometryType = geometry.geometryType;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            [self writePoint:(SFPoint *)geometry withWriter:writer];
            break;
        case SF_LINESTRING:
            [self writeLineString:(SFLineString *)geometry withWriter:writer];
            break;
        case SF_POLYGON:
            [self writePolygon:(SFPolygon *)geometry withWriter:writer];
            break;
        case SF_MULTIPOINT:
            [self writeMultiPoint:(SFMultiPoint *)geometry withWriter:writer];
            break;
        case SF_MULTILINESTRING:
            [self writeMultiLineString:(SFMultiLineString *)geometry withWriter:writer];
            break;
        case SF_MULTIPOLYGON:
            [self writeMultiPolygon:(SFMultiPolygon *)geometry withWriter:writer];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            [self writeGeometryCollection:(SFGeometryCollection *)geometry withWriter:writer];
            break;
        case SF_CIRCULARSTRING:
            [self writeCircularString:(SFCircularString *)geometry withWriter:writer];
            break;
        case SF_COMPOUNDCURVE:
            [self writeCompoundCurve:(SFCompoundCurve *)geometry withWriter:writer];
            break;
        case SF_CURVEPOLYGON:
            [self writeCurvePolygon:(SFCurvePolygon *)geometry withWriter:writer];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            [self writePolyhedralSurface:(SFPolyhedralSurface *)geometry withWriter:writer];
            break;
        case SF_TIN:
            [self writeTIN:(SFTIN *)geometry withWriter:writer];
            break;
        case SF_TRIANGLE:
            [self writeTriangle:(SFTriangle *)geometry withWriter:writer];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
}

+(void) writePoint: (SFPoint *) point withWriter: (SFByteWriter *) writer{
    
    [writer writeDouble:point.x];
    [writer writeDouble:point.y];
    
    if(point.hasZ){
        [writer writeDouble:point.z];
    }
    
    if(point.hasM){
        [writer writeDouble:point.m];
    }
}

+(void) writeLineString: (SFLineString *) lineString withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[lineString numPoints] withWriter:writer];
    
    for(SFPoint * point in lineString.points){
        [self writePoint:point withWriter:writer];
    }
}

+(void) writePolygon: (SFPolygon *) polygon withWriter: (SFByteWriter *) writer{

    [self writeInt:[polygon numRings] withWriter:writer];
    
    for(SFLineString * lineString in polygon.rings){
        [self writeLineString:lineString withWriter:writer];
    }
}

+(void) writeMultiPoint: (SFMultiPoint *) multiPoint withWriter: (SFByteWriter *) writer{

    [self writeInt:[multiPoint numPoints] withWriter:writer];
    
    for(SFPoint * point in [multiPoint points]){
        [self writeGeometry:point withWriter:writer];
    }
}

+(void) writeMultiLineString: (SFMultiLineString *) multiLineString withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[multiLineString numLineStrings] withWriter:writer];
    
    for(SFLineString * lineString in [multiLineString lineStrings]){
        [self writeGeometry:lineString withWriter:writer];
    }
}

+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[multiPolygon numPolygons] withWriter:writer];
    
    for(SFPolygon * polygon in [multiPolygon polygons]){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[geometryCollection numGeometries] withWriter:writer];
    
    for(SFGeometry * geometry in geometryCollection.geometries){
        [self writeGeometry:geometry withWriter:writer];
    }
}

+(void) writeCircularString: (SFCircularString *) circularString withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[circularString numPoints] withWriter:writer];
    
    for(SFPoint * point in circularString.points){
        [self writePoint:point withWriter:writer];
    }
}

+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[compoundCurve numLineStrings] withWriter:writer];
    
    for(SFLineString * lineString in compoundCurve.lineStrings){
        [self writeGeometry:lineString withWriter:writer];
    }
}

+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[curvePolygon numRings] withWriter:writer];
    
    for(SFCurve * ring in curvePolygon.rings){
        [self writeGeometry:ring withWriter:writer];
    }
}

+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[polyhedralSurface numPolygons] withWriter:writer];
    
    for(SFPolygon * polygon in polyhedralSurface.polygons){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeTIN: (SFTIN *) tin withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[tin numPolygons] withWriter:writer];
    
    for(SFPolygon * polygon in tin.polygons){
        [self writeGeometry:polygon withWriter:writer];
    }
}

+(void) writeTriangle: (SFTriangle *) triangle withWriter: (SFByteWriter *) writer{
    
    [self writeInt:[triangle numRings] withWriter:writer];
    
    for(SFLineString * ring in triangle.rings){
        [self writeLineString:ring withWriter:writer];
    }
}

+(void) writeInt: (int) count withWriter: (SFByteWriter *) writer{
    [writer writeInt:[NSNumber numberWithInt:count]];
}

@end
