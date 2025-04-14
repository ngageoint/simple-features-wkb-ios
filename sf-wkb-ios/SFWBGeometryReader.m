//
//  SFWBGeometryReader.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <SimpleFeaturesWKB/SFWBGeometryReader.h>
#import <SimpleFeaturesWKB/SFWBGeometryCodes.h>

@interface SFWBGeometryReader()

/**
 * Byte Reader
 */
@property (nonatomic, strong) SFByteReader *reader;

@end

@implementation SFWBGeometryReader

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
    SFWBGeometryReader *reader = [[SFWBGeometryReader alloc] initWithData:data];
    return [reader readWithFilter:filter andExpectedType:expectedType];
}

-(instancetype) initWithData: (NSData *) data{
    return [self initWithReader:[[SFByteReader alloc] initWithData:data]];
}

-(instancetype) initWithReader: (SFByteReader *) reader{
    self = [super init];
    if(self != nil){
        _reader = reader;
    }
    return self;
}

-(SFByteReader *) byteReader{
    return _reader;
}

-(SFGeometry *) read{
    return [self readWithFilter:nil andExpectedType:nil];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readWithFilter:filter andExpectedType:nil];
}

-(SFGeometry *) readWithExpectedType: (Class) expectedType{
    return [self readWithFilter:nil andExpectedType:expectedType];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    return [self readWithFilter:filter inType:SF_NONE andExpectedType:expectedType];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter inType: (SFGeometryType) containingType andExpectedType: (Class) expectedType{
    
    CFByteOrder originalByteOrder = [_reader byteOrder];
    
    // Read the byte order and geometry type
    SFWBGeometryTypeInfo *geometryTypeInfo = [self readGeometryType];
    
    SFGeometryType geometryType = [geometryTypeInfo geometryType];
    BOOL hasZ = [geometryTypeInfo hasZ];
    BOOL hasM = [geometryTypeInfo hasM];
    
    SFGeometry *geometry = nil;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            geometry = [self readPointWithHasZ:hasZ andHasM:hasM];
            break;
        case SF_LINESTRING:
            geometry = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_POLYGON:
            geometry = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOINT:
            geometry = [self readMultiPointWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTILINESTRING:
            geometry = [self readMultiLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_MULTIPOLYGON:
            geometry = [self readMultiPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            geometry = [self readGeometryCollectionWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CIRCULARSTRING:
            geometry = [self readCircularStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_COMPOUNDCURVE:
            geometry = [self readCompoundCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVEPOLYGON:
            geometry = [self readCurvePolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            geometry = [self readPolyhedralSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TIN:
            geometry = [self readTINWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        case SF_TRIANGLE:
            geometry = [self readTriangleWithFilter:filter andHasZ:hasZ andHasM:hasM];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %ld", geometryType];
    }
    
    if(![SFWBGeometryReader filter:filter geometry:geometry inType:containingType]){
        geometry = nil;
    }
    
    // If there is an expected type, verify the geometry if of that type
    if (expectedType != nil && geometry != nil && ![geometry isKindOfClass:expectedType]){
        [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type. Expected: %@, Actual: %@", NSStringFromClass(expectedType), NSStringFromClass([geometry class])];
    }
    
    // Restore the byte order
    [_reader setByteOrder:originalByteOrder];
    
    return geometry;
}

-(SFWBGeometryTypeInfo *) readGeometryType{
    
    // Read the single byte order byte
    NSNumber *byteOrderValue = [_reader readByte];
    int byteOrderIntValue = [byteOrderValue intValue];
    CFByteOrder byteOrder = CFByteOrderUnknown;
    if(byteOrderIntValue == 0){
        byteOrder = CFByteOrderBigEndian;
    }else if(byteOrderIntValue == 1){
        byteOrder = CFByteOrderLittleEndian;
    }else{
        [NSException raise:@"Unexpected Byte Order" format:@"Unexpected byte order value: %@", byteOrderValue];
    }
    [_reader setByteOrder:byteOrder];
    
    // Read the geometry type integer
    int geometryTypeCode = [[_reader readInt] intValue];
    
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
    SFGeometryType geometryType = [SFWBGeometryCodes geometryTypeFromCode:geometryTypeCode];
    
    // Determine if the geometry has a z (3d) or m (linear referencing
    // system) value
    if (!hasZ) {
        hasZ = [SFWBGeometryCodes hasZFromCode:geometryTypeCode];
    }
    BOOL hasM = [SFWBGeometryCodes hasMFromCode:geometryTypeCode];
    
    SFWBGeometryTypeInfo *geometryInfo = [[SFWBGeometryTypeInfo alloc] initWithCode:geometryTypeCode andType:geometryType andHasZ:hasZ andHasM:hasM];
    
    return geometryInfo;
}

-(SFPoint *) readPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    NSDecimalNumber *x = [_reader readDouble];
    NSDecimalNumber *y = [_reader readDouble];
    
    SFPoint *point = [SFPoint pointWithHasZ:hasZ andHasM:hasM andX:x andY:y];
    
    if(hasZ){
        NSDecimalNumber *z = [_reader readDouble];
        [point setZ:z];
    }
    
    if(hasM){
        NSDecimalNumber *m = [_reader readDouble];
        [point setM:m];
    }
    
    return point;
}

-(SFLineString *) readLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readLineStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFLineString *) readLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFLineString *lineString = [SFLineString lineStringWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = [self readPointWithHasZ:hasZ andHasM:hasM];
        if([SFWBGeometryReader filter:filter geometry:point inType:SF_LINESTRING]){
            [lineString addPoint:point];
        }
    }
    
    return lineString;
}

-(SFPolygon *) readPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFPolygon *) readPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    SFPolygon *polygon = [SFPolygon polygonWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[_reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString *ring = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
        if([SFWBGeometryReader filter:filter geometry:ring inType:SF_POLYGON]){
            [polygon addRing:ring];
        }
    }
    
    return polygon;
}

-(SFMultiPoint *) readMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPointWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiPoint *) readMultiPointWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = [SFMultiPoint multiPointWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = (SFPoint *)[self readWithFilter:filter inType:SF_MULTIPOINT andExpectedType:[SFPoint class]];
        if(point != nil){
            [multiPoint addPoint:point];
        }
    }
    
    return multiPoint;
}

-(SFMultiLineString *) readMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiLineStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiLineString *) readMultiLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = [SFMultiLineString multiLineStringWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[_reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString *lineString = (SFLineString *)[self readWithFilter:filter inType:SF_MULTILINESTRING andExpectedType:[SFLineString class]];
        if(lineString != nil){
            [multiLineString addLineString:lineString];
        }
    }
    
    return multiLineString;
}

-(SFMultiPolygon *) readMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiPolygon *) readMultiPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = [SFMultiPolygon multiPolygonWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[self readWithFilter:filter inType:SF_MULTIPOLYGON andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [multiPolygon addPolygon:polygon];
        }
    }
    
    return multiPolygon;
}

-(SFGeometryCollection *) readGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readGeometryCollectionWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFGeometryCollection *) readGeometryCollectionWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
    
    int numGeometries = [[_reader readInt] intValue];
    
    for(int i = 0; i < numGeometries; i++){
        SFGeometry *geometry = [self readWithFilter:filter inType:SF_GEOMETRYCOLLECTION andExpectedType:[SFGeometry class]];
        if(geometry != nil){
            [geometryCollection addGeometry:geometry];
        }
    }
    
    return geometryCollection;
}

-(SFCircularString *) readCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCircularStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCircularString *) readCircularStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCircularString *circularString = [SFCircularString circularStringWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        SFPoint *point = [self readPointWithHasZ:hasZ andHasM:hasM];
        if([SFWBGeometryReader filter:filter geometry:point inType:SF_CIRCULARSTRING]){
            [circularString addPoint:point];
        }
    }
    
    return circularString;
}

-(SFCompoundCurve *) readCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCompoundCurveWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCompoundCurve *) readCompoundCurveWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCompoundCurve *compoundCurve = [SFCompoundCurve compoundCurveWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[_reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        SFLineString *lineString = (SFLineString *)[self readWithFilter:filter inType:SF_COMPOUNDCURVE andExpectedType:[SFLineString class]];
        if(lineString != nil){
            [compoundCurve addLineString:lineString];
        }
    }
    
    return compoundCurve;
}

-(SFCurvePolygon *) readCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCurvePolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCurvePolygon *) readCurvePolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = [SFCurvePolygon curvePolygonWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[_reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFCurve *ring = (SFCurve *)[self readWithFilter:filter inType:SF_CURVEPOLYGON andExpectedType:[SFCurve class]];
        if(ring != nil){
            [curvePolygon addRing:ring];
        }
    }
    
    return curvePolygon;
}

-(SFPolyhedralSurface *) readPolyhedralSurfaceWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolyhedralSurfaceWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFPolyhedralSurface *) readPolyhedralSurfaceWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolyhedralSurface *polyhedralSurface = [SFPolyhedralSurface polyhedralSurfaceWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[self readWithFilter:filter inType:SF_POLYHEDRALSURFACE andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [polyhedralSurface addPolygon:polygon];
        }
    }
    
    return polyhedralSurface;
}

-(SFTIN *) readTINWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTINWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFTIN *) readTINWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTIN *tin = [SFTIN tinWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[_reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        SFPolygon *polygon = (SFPolygon *)[self readWithFilter:filter inType:SF_TIN andExpectedType:[SFPolygon class]];
        if(polygon != nil){
            [tin addPolygon:polygon];
        }
    }
    
    return tin;
}

-(SFTriangle *) readTriangleWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTriangleWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFTriangle *) readTriangleWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTriangle *triangle = [SFTriangle triangleWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[_reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        SFLineString *ring = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
        if([SFWBGeometryReader filter:filter geometry:ring inType:SF_TRIANGLE]){
            [triangle addRing:ring];
        }
    }
    
    return triangle;
}

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader{
    return [self readGeometryWithReader:reader andFilter:nil andExpectedType:nil];
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

+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (SFGeometryType) containingType andExpectedType: (Class) expectedType{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readWithFilter:filter inType:containingType andExpectedType:expectedType];
}

+(SFWBGeometryTypeInfo *) readGeometryTypeWithReader: (SFByteReader *) reader{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryType];
}

+(SFPoint *) readPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPointWithHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readLineStringWithHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPointWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPointWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiLineStringWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryCollectionWithHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryCollectionWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCircularStringWithHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCircularStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCompoundCurveWithHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCompoundCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCurvePolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCurvePolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolyhedralSurfaceWithHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolyhedralSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTINWithHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTINWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTriangleWithHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWBGeometryReader *geometryReader = [[SFWBGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTriangleWithFilter:filter andHasZ:hasZ andHasM:hasM];
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
+(BOOL) filter: (NSObject<SFGeometryFilter> *) filter geometry: (SFGeometry *) geometry inType: (SFGeometryType) containingType{
    return filter == nil || geometry == nil || [filter filterGeometry:geometry inType:containingType];
}

@end
