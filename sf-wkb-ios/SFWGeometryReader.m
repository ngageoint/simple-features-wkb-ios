//
//  SFWGeometryReader.m
//  sf-wkb-ios
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

+(SFGeometry *) readGeometryWithData: (NSData *) data{
    return [self readGeometryWithData:data andFilter:nil];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readGeometryWithData:data andFilter:filter andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data andExpectedType: (Class) expectedType{
    return [self readGeometryWithData:data andFilter:nil andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    SFByteReader *reader = [[SFByteReader alloc] initWithData:data];
    return [self readGeometryWithReader:reader andFilter:filter andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader{
    return [self readGeometryWithReader:reader andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readGeometryWithReader:reader andFilter:filter andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andExpectedType: (Class) expectedType{
    return [self readGeometryWithReader:reader andFilter:nil andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    return [self readGeometryWithReader:reader andFilter:filter inType:SF_NONE andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (enum SFGeometryType) containingType andExpectedType: (Class) expectedType{
    
    CFByteOrder originalByteOrder = [reader byteOrder];
    
    // Read the byte order and geometry type
    SFWGeometryTypeInfo *geometryTypeInfo = [self readGeometryTypeWithReader:reader];
    
    enum SFGeometryType geometryType = [geometryTypeInfo geometryType];
    BOOL hasZ = [geometryTypeInfo hasZ];
    BOOL hasM = [geometryTypeInfo hasM];
    
    SFGeometry *geometry = nil;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            geometry = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case SF_LINESTRING:
            geometry = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_POLYGON:
            geometry = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOINT:
            geometry = [self readMultiPointWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTILINESTRING:
            geometry = [self readMultiLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOLYGON:
            geometry = [self readMultiPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            geometry = [self readGeometryCollectionWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CIRCULARSTRING:
            geometry = [self readCircularStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_COMPOUNDCURVE:
            geometry = [self readCompoundCurveWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVEPOLYGON:
            geometry = [self readCurvePolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            geometry = [self readPolyhedralSurfaceWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TIN:
            geometry = [self readTINWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TRIANGLE:
            geometry = [self readTriangleWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
    if(![self filter:filter geometry:geometry inType:containingType]){
        geometry = nil;
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
    NSNumber *byteOrderValue = [reader readByte];
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
    NSScanner *scanner = [NSScanner scannerWithString:WKB25D];
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
    
    NSDecimalNumber *x = [reader readDouble];
    NSDecimalNumber *y = [reader readDouble];
    
    SFPoint *point = [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:x andY:y];
    
    if(hasZ){
        NSDecimalNumber *z = [reader readDouble];
        [point setZ:z];
    }
    
    if(hasM){
        NSDecimalNumber *m = [reader readDouble];
        [point setM:m];
    }
    
    return point;
}

+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readLineStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFLineString *lineString = [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = [SFWGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        if([self filter:filter geometry:point inType:SF_LINESTRING]){
            [lineString addPoint:point];
        }
    }
    
    return lineString;
}

+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    SFPolygon *polygon = [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString *ring = [SFWGeometryReader readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
        if([self filter:filter geometry:ring inType:SF_POLYGON]){
            [polygon addRing:ring];
        }
    }
    
    return polygon;
}

+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPointWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = [[SFMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = (SFPoint *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_MULTIPOINT andExpectedType:[SFPoint class]];
        if(point != nil){
            [multiPoint addPoint:point];
        }
    }
    
    return multiPoint;
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiLineStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = [[SFMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString *lineString = (SFLineString *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_MULTILINESTRING andExpectedType:[SFLineString class]];
        if(lineString != nil){
            [multiLineString addLineString:lineString];
        }
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = [[SFMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_MULTIPOLYGON andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [multiPolygon addPolygon:polygon];
        }
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readGeometryCollectionWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numGeometries = [[reader readInt] intValue];
    
    for(int i = 0; i < numGeometries; i++){
        SFGeometry *geometry = [SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_GEOMETRYCOLLECTION andExpectedType:[SFGeometry class]];
        if(geometry != nil){
            [geometryCollection addGeometry:geometry];
        }
    }
    
    return geometryCollection;
}

+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCircularStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCircularString *circularString = [[SFCircularString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = [SFWGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        if([self filter:filter geometry:point inType:SF_CIRCULARSTRING]){
            [circularString addPoint:point];
        }
    }
    
    return circularString;
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCompoundCurveWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCompoundCurve *compoundCurve = [[SFCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString *lineString = (SFLineString *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_COMPOUNDCURVE andExpectedType:[SFLineString class]];
        if(lineString != nil){
            [compoundCurve addLineString:lineString];
        }
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCurvePolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = [[SFCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFCurve *ring = (SFCurve *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_CURVEPOLYGON andExpectedType:[SFCurve class]];
        if(ring != nil){
            [curvePolygon addRing:ring];
        }
    }
    
    return curvePolygon;
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolyhedralSurfaceWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolyhedralSurface *polyhedralSurface = [[SFPolyhedralSurface alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_POLYHEDRALSURFACE andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [polyhedralSurface addPolygon:polygon];
        }
    }
    
    return polyhedralSurface;
}

+(SFTIN *) readTINWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTINWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTIN *tin = [[SFTIN alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[SFWGeometryReader readGeometryWithReader:reader andFilter:filter inType:SF_TIN andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [tin addPolygon:polygon];
        }
    }
    
    return tin;
}

+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTriangleWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTriangle *triangle = [[SFTriangle alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString *ring = [SFWGeometryReader readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
        if([self filter:filter geometry:ring inType:SF_TRIANGLE]){
            [triangle addRing:ring];
        }
    }
    
    return triangle;
}

/**
 * Filter the geometry
 *
 * @param filter
 *            geometry filter or null
 * @param containingType
 *            containing geometry type
 * @param geometry
 *            geometry or null
 * @return true if passes filter
 */
+(BOOL) filter: (NSObject<SFGeometryFilter> *) filter geometry: (SFGeometry *) geometry inType: (enum SFGeometryType) containingType{
    return filter == nil || geometry == nil || [filter filterGeometry:geometry inType:containingType];
}

@end
