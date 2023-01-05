//
//  SFWBGeometryWriter.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFWBGeometryWriter.h"
#import "SFWBGeometryCodes.h"

@interface SFWBGeometryWriter()

/**
 * Byte Writer
 */
@property (nonatomic, strong) SFByteWriter *writer;

@end

@implementation SFWBGeometryWriter

+(NSData *) writeGeometry: (SFGeometry *) geometry{
    return [self writeGeometry:geometry inByteOrder:DEFAULT_WRITE_BYTE_ORDER];
}

+(NSData *) writeGeometry: (SFGeometry *) geometry inByteOrder: (CFByteOrder) byteOrder{
    NSData *data = nil;
    SFWBGeometryWriter *writer = [[SFWBGeometryWriter alloc] initWithByteOrder:byteOrder];
    @try {
        [writer write:geometry];
        data = [writer data];
    } @finally {
        [writer close];
    }
    return data;
}

-(instancetype) init{
    return [self initWithByteOrder:DEFAULT_WRITE_BYTE_ORDER];
}

-(instancetype) initWithByteOrder: (CFByteOrder) byteOrder{
    return [self initWithWriter:[[SFByteWriter alloc] initWithByteOrder:byteOrder]];
}

-(instancetype) initWithWriter: (SFByteWriter *) writer{
    self = [super init];
    if(self != nil){
        _writer = writer;
    }
    return self;
}

-(SFByteWriter *) byteWriter{
    return _writer;
}

-(NSData *) data{
    return [_writer data];
}

-(void) close{
    [_writer close];
}

-(void) write: (SFGeometry *) geometry{

    // Write the single byte order byte
    uint8_t byteOrderInt = -1;
    if(_writer.byteOrder == CFByteOrderBigEndian){
        byteOrderInt = 0;
    }else if(_writer.byteOrder == CFByteOrderLittleEndian){
        byteOrderInt = 1;
    }else{
        [NSException raise:@"Unexpected Byte Order" format:@"Unexpected byte order: %ld", _writer.byteOrder];
    }
    NSNumber *byteOrder = [NSNumber numberWithInt:byteOrderInt];
    [_writer writeByte:byteOrder];
    
    // Write the geometry type integer
    [self writeInt:[SFWBGeometryCodes wkbCodeFromGeometry:geometry]];
    
    enum SFGeometryType geometryType = geometry.geometryType;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            [self writePoint:(SFPoint *)geometry];
            break;
        case SF_LINESTRING:
            [self writeLineString:(SFLineString *)geometry];
            break;
        case SF_POLYGON:
            [self writePolygon:(SFPolygon *)geometry];
            break;
        case SF_MULTIPOINT:
        case SF_MULTILINESTRING:
        case SF_MULTIPOLYGON:
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            [self writeGeometryCollection:(SFGeometryCollection *)geometry];
            break;
        case SF_CIRCULARSTRING:
            [self writeCircularString:(SFCircularString *)geometry];
            break;
        case SF_COMPOUNDCURVE:
            [self writeCompoundCurve:(SFCompoundCurve *)geometry];
            break;
        case SF_CURVEPOLYGON:
            [self writeCurvePolygon:(SFCurvePolygon *)geometry];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            [self writePolyhedralSurface:(SFPolyhedralSurface *)geometry];
            break;
        case SF_TIN:
            [self writeTIN:(SFTIN *)geometry];
            break;
        case SF_TRIANGLE:
            [self writeTriangle:(SFTriangle *)geometry];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
}

-(void) writePoint: (SFPoint *) point{
    
    [_writer writeDouble:point.x];
    [_writer writeDouble:point.y];
    
    if(point.hasZ){
        [_writer writeDouble:point.z];
    }
    
    if(point.hasM){
        [_writer writeDouble:point.m];
    }
}

-(void) writeLineString: (SFLineString *) lineString{
    
    [self writeInt:[lineString numPoints]];
    
    for(SFPoint *point in lineString.points){
        [self writePoint:point];
    }
}

-(void) writePolygon: (SFPolygon *) polygon{

    [self writeInt:[polygon numRings]];
    
    for(SFLineString *lineString in polygon.rings){
        [self writeLineString:lineString];
    }
}

-(void) writeMultiPoint: (SFMultiPoint *) multiPoint{

    [self writeInt:[multiPoint numPoints]];
    
    for(SFPoint *point in [multiPoint points]){
        [self write:point];
    }
}

-(void) writeMultiLineString: (SFMultiLineString *) multiLineString{
    
    [self writeInt:[multiLineString numLineStrings]];
    
    for(SFLineString *lineString in [multiLineString lineStrings]){
        [self write:lineString];
    }
}

-(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon{
    
    [self writeInt:[multiPolygon numPolygons]];
    
    for(SFPolygon *polygon in [multiPolygon polygons]){
        [self write:polygon];
    }
}

-(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection{
    
    [self writeInt:[geometryCollection numGeometries]];
    
    for(SFGeometry *geometry in geometryCollection.geometries){
        [self write:geometry];
    }
}

-(void) writeCircularString: (SFCircularString *) circularString{
    
    [self writeInt:[circularString numPoints]];
    
    for(SFPoint *point in circularString.points){
        [self writePoint:point];
    }
}

-(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve{
    
    [self writeInt:[compoundCurve numLineStrings]];
    
    for(SFLineString *lineString in compoundCurve.lineStrings){
        [self write:lineString];
    }
}

-(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon{
    
    [self writeInt:[curvePolygon numRings]];
    
    for(SFCurve *ring in curvePolygon.rings){
        [self write:ring];
    }
}

-(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    
    [self writeInt:[polyhedralSurface numPolygons]];
    
    for(SFPolygon *polygon in polyhedralSurface.polygons){
        [self write:polygon];
    }
}

-(void) writeTIN: (SFTIN *) tin{
    
    [self writeInt:[tin numPolygons]];
    
    for(SFPolygon *polygon in tin.polygons){
        [self write:polygon];
    }
}

-(void) writeTriangle: (SFTriangle *) triangle{
    
    [self writeInt:[triangle numRings]];
    
    for(SFLineString *ring in triangle.rings){
        [self writeLineString:ring];
    }
}

-(void) writeInt: (int) count{
    [SFWBGeometryWriter writeInt:count withWriter:_writer];
}

+(void) writeGeometry: (SFGeometry *) geometry withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter write:geometry];
}

+(void) writePoint: (SFPoint *) point withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writePoint:point];
}

+(void) writeLineString: (SFLineString *) lineString withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeLineString:lineString];
}

+(void) writePolygon: (SFPolygon *) polygon withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writePolygon:polygon];
}

+(void) writeMultiPoint: (SFMultiPoint *) multiPoint withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeMultiPoint:multiPoint];
}

+(void) writeMultiLineString: (SFMultiLineString *) multiLineString withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeMultiLineString:multiLineString];
}

+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeMultiPolygon:multiPolygon];
}

+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeGeometryCollection:geometryCollection];
}

+(void) writeCircularString: (SFCircularString *) circularString withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeCircularString:circularString];
}

+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeCompoundCurve:compoundCurve];
}

+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeCurvePolygon:curvePolygon];
}

+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writePolyhedralSurface:polyhedralSurface];
}

+(void) writeTIN: (SFTIN *) tin withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeTIN:tin];
}

+(void) writeTriangle: (SFTriangle *) triangle withWriter: (SFByteWriter *) writer{
    SFWBGeometryWriter *geometryWriter = [[SFWBGeometryWriter alloc] initWithWriter:writer];
    [geometryWriter writeTriangle:triangle];
}

+(void) writeInt: (int) count withWriter: (SFByteWriter *) writer{
    [writer writeInt:[NSNumber numberWithInt:count]];
}

@end
