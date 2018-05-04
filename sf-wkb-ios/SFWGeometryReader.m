//
//  SFWGeometryReader.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFWGeometryReader.h"
#import "SFWGeometryCodes.h"

@implementation SFWGeometryReader

/**
 * 2.5D bit
 */
static NSString *WKB25D = @"0x80000000";

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader{
    SFGeometry * geometry = [self readGeometryWithReader:reader andExpectedType:nil];
    return geometry;
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andExpectedType: (Class) expectedType{
    
    CFByteOrder originalByteOrder = [reader byteOrder];
    
    // Read the byte order and geometry type
    SFWGeometryTypeInfo *geometryTypeInfo = [self readGeometryTypeWithReader:reader];
    
    enum SFGeometryType geometryType = [geometryTypeInfo geometryType];
    BOOL hasZ = [geometryTypeInfo hasZ];
    BOOL hasM = [geometryTypeInfo hasM];
    
    SFGeometry * geometry = nil;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            geometry = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_LINESTRING:
            geometry = [self readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_POLYGON:
            geometry = [self readPolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOINT:
            geometry = [self readMultiPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTILINESTRING:
            geometry = [self readMultiLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOLYGON:
            geometry = [self readMultiPolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            geometry = [self readGeometryCollectionWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CIRCULARSTRING:
            geometry = [self readCircularStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_COMPOUNDCURVE:
            geometry = [self readCompoundCurveWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVEPOLYGON:
            geometry = [self readCurvePolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            geometry = [self readPolyhedralSurfaceWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TIN:
            geometry = [self readTINWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TRIANGLE:
            geometry = [self readTriangleWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
    // If there is an expected type, verify the geometry if of that type
    if (expectedType != nil && geometry != nil && ![geometry isKindOfClass:expectedType]){
        [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type. Expected: %@, Actual: %@", NSStringFromClass(expectedType), NSStringFromClass([geometry class])];
    }
    
    // Restore the byte order
    [reader setByteOrder:originalByteOrder];
    
    return geometry;
}

+(SFWGeometryTypeInfo *) readGeometryTypeWithReader: (SFByteReader *) reader{
    
    // Read the single byte order byte
    NSNumber * byteOrderValue = [reader readByte];
    int byteOrderIntValue = [byteOrderValue intValue];
    CFByteOrder byteOrder = CFByteOrderUnknown;
    if(byteOrderIntValue == 0){
        byteOrder = CFByteOrderBigEndian;
    }else if(byteOrderIntValue == 1){
        byteOrder = CFByteOrderLittleEndian;
    }else{
        [NSException raise:@"Unexpected Byte Order" format:@"Unexpected byte order value: %@", byteOrderValue];
    }
    [reader setByteOrder:byteOrder];
    
    // Read the geometry type integer
    int geometryTypeCode = [[reader readInt] intValue];
    
    // Check for 2.5D geometry types
    BOOL hasZ = NO;
    unsigned int wkb25d;
    NSScanner* scanner = [NSScanner scannerWithString:WKB25D];
    [scanner scanHexInt:&wkb25d];
    if (geometryTypeCode > wkb25d) {
        hasZ = YES;
        geometryTypeCode -= wkb25d;
    }
    
    // Determine the geometry type
    enum SFGeometryType geometryType = [SFWGeometryCodes geometryTypeFromCode:geometryTypeCode];
    
    // Determine if the geometry has a z (3d) or m (linear referencing
    // system) value
    if (!hasZ) {
        hasZ = [SFWGeometryCodes hasZFromCode:geometryTypeCode];
    }
    BOOL hasM = [SFWGeometryCodes hasMFromCode:geometryTypeCode];
    
    SFWGeometryTypeInfo *geometryInfo = [[SFWGeometryTypeInfo alloc] initWithCode:geometryTypeCode andType:geometryType andHasZ:hasZ andHasM:hasM];
    
    return geometryInfo;
}

+(SFPoint *) readPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    NSDecimalNumber * x = [reader readDouble];
    NSDecimalNumber * y = [reader readDouble];
    
    SFPoint * point = [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:x andY:y];
    
    if(hasZ){
        NSDecimalNumber * z = [reader readDouble];
        [point setZ:z];
    }
    
    if(hasM){
        NSDecimalNumber * m = [reader readDouble];
        [point setM:m];
    }
    
    return point;
}

+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFLineString * lineString = [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint * point = [SFWGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        [lineString addPoint:point];
    }
    
    return lineString;
}

+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    SFPolygon * polygon = [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString * ring = [SFWGeometryReader readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
        [polygon addRing:ring];
    }
    
    return polygon;
}

+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint * multiPoint = [[SFMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint * point = (SFPoint *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFPoint class]];
        [multiPoint addPoint:point];
    }
    
    return multiPoint;
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString * multiLineString = [[SFMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString * lineString = (SFLineString *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFLineString class]];
        [multiLineString addLineString:lineString];
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon * multiPolygon = [[SFMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon * polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFPolygon class]];
        [multiPolygon addPolygon:polygon];
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection * geometryCollection = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numGeometries = [[reader readInt] intValue];
    
    for(int i = 0; i < numGeometries; i++){
        SFGeometry * geometry = [SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFGeometry class]];
        [geometryCollection addGeometry:geometry];
    }
    
    return geometryCollection;
}

+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCircularString * circularString = [[SFCircularString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint * point = [SFWGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        [circularString addPoint:point];
    }
    
    return circularString;
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCompoundCurve * compoundCurve = [[SFCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString * lineString = (SFLineString *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFLineString class]];
        [compoundCurve addLineString:lineString];
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon * curvePolygon = [[SFCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFCurve * ring = (SFCurve *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFCurve class]];
        [curvePolygon addRing:ring];
    }
    
    return curvePolygon;
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolyhedralSurface * polyhedralSurface = [[SFPolyhedralSurface alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon * polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFPolygon class]];
        [polyhedralSurface addPolygon:polygon];
    }
    
    return polyhedralSurface;
}

+(SFTIN *) readTINWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTIN * tin = [[SFTIN alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon * polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andExpectedType:[SFPolygon class]];
        [tin addPolygon:polygon];
    }
    
    return tin;
}

+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTriangle * triangle = [[SFTriangle alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString * ring = [SFWGeometryReader readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
        [triangle addRing:ring];
    }
    
    return triangle;
}

@end
