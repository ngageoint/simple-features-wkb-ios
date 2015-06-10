//
//  WKBGeometryReader.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryReader.h"

@implementation WKBGeometryReader

+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader{
    WKBGeometry * geometry = [self readGeometryWithReader:reader andExpectedType:nil];
    return geometry;
}

+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader andExpectedType: (Class) expectedType{
    
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
    CFByteOrder originalByteOrder = [reader byteOrder];
    [reader setByteOrder:byteOrder];
    
    // Read the geometry type integer
    int geometryTypeWkbCode = [[reader readInt] intValue];
    
    // Look at the last 2 digits to find the geometry type code (1 - 14)
    int geometryTypeCode = geometryTypeWkbCode % 1000;
    
    // Look at the first digit to find the options (z when 1 or 3, m when 2
    // or 3)
    int geometryTypeMode = geometryTypeWkbCode / 1000;
    
    // Determine if the geometry has a z (3d) or m (linear referencing
    // system) value
    BOOL hasZ = false;
    BOOL hasM = false;
    switch (geometryTypeMode) {
        case 0:
            break;
            
        case 1:
            hasZ = true;
            break;
            
        case 2:
            hasM = true;
            break;
            
        case 3:
            hasZ = true;
            hasM = true;
            break;
    }
    
    enum WKBGeometryType geometryType = [WKBGeometryTypes fromCode:geometryTypeCode];
    
    WKBGeometry * geometry = nil;
    
    switch (geometryType) {
            
        case WKB_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
        case WKB_POINT:
            geometry = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_LINESTRING:
            geometry = [self readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_POLYGON:
            geometry = [self readPolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_MULTIPOINT:
            geometry = [self readMultiPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_MULTILINESTRING:
            geometry = [self readMultiLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_MULTIPOLYGON:
            geometry = [self readMultiPolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_GEOMETRYCOLLECTION:
            geometry = [self readGeometryCollectionWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_CIRCULARSTRING:
            geometry = [self readCircularStringWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_COMPOUNDCURVE:
            geometry = [self readCompoundCurveWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_CURVEPOLYGON:
            geometry = [self readCurvePolygonWithReader:reader andHasZ:hasZ andHasM:hasM];
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
            geometry = [self readPolyhedralSurfaceWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_TIN:
            geometry = [self readTINWithReader:reader andHasZ:hasZ andHasM:hasM];
            break;
        case WKB_TRIANGLE:
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

+(WKBPoint *) readPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    NSDecimalNumber * x = [reader readDouble];
    NSDecimalNumber * y = [reader readDouble];
    
    WKBPoint * point = [[WKBPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:x andY:y];
    
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

+(WKBLineString *) readLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBLineString * lineString = [[WKBLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        WKBPoint * point = [WKBGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        [lineString addPoint:point];
    }
    
    return lineString;
}

+(WKBPolygon *) readPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    WKBPolygon * polygon = [[WKBPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        WKBLineString * ring = [WKBGeometryReader readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
        [polygon addRing:ring];
    }
    
    return polygon;
}

+(WKBMultiPoint *) readMultiPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiPoint * multiPoint = [[WKBMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        WKBPoint * point = (WKBPoint *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBPoint class]];
        [multiPoint addPoint:point];
    }
    
    return multiPoint;
}

+(WKBMultiLineString *) readMultiLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiLineString * multiLineString = [[WKBMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        WKBLineString * lineString = (WKBLineString *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBLineString class]];
        [multiLineString addLineString:lineString];
    }
    
    return multiLineString;
}

+(WKBMultiPolygon *) readMultiPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiPolygon * multiPolygon = [[WKBMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        WKBPolygon * polygon = (WKBPolygon *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBPolygon class]];
        [multiPolygon addPolygon:polygon];
    }
    
    return multiPolygon;
}

+(WKBGeometryCollection *) readGeometryCollectionWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBGeometryCollection * geometryCollection = [[WKBGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numGeometries = [[reader readInt] intValue];
    
    for(int i = 0; i < numGeometries; i++){
        WKBGeometry * geometry = [WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBGeometry class]];
        [geometryCollection addGeometry:geometry];
    }
    
    return geometryCollection;
}

+(WKBCircularString *) readCircularStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBCircularString * circularString = [[WKBCircularString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPoints = [[reader readInt] intValue];
    
    for(int i = 0; i < numPoints; i++){
        WKBPoint * point = [WKBGeometryReader readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        [circularString addPoint:point];
    }
    
    return circularString;
}

+(WKBCompoundCurve *) readCompoundCurveWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBCompoundCurve * compoundCurve = [[WKBCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numLineStrings = [[reader readInt] intValue];
    
    for(int i = 0; i < numLineStrings; i++){
        WKBLineString * lineString = (WKBLineString *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBLineString class]];
        [compoundCurve addLineString:lineString];
    }
    
    return compoundCurve;
}

+(WKBCurvePolygon *) readCurvePolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBCurvePolygon * curvePolygon = [[WKBCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        WKBCurve * ring = (WKBCurve *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBCurve class]];
        [curvePolygon addRing:ring];
    }
    
    return curvePolygon;
}

+(WKBPolyhedralSurface *) readPolyhedralSurfaceWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBPolyhedralSurface * polyhedralSurface = [[WKBPolyhedralSurface alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        WKBPolygon * polygon = (WKBPolygon *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBPolygon class]];
        [polyhedralSurface addPolygon:polygon];
    }
    
    return polyhedralSurface;
}

+(WKBTIN *) readTINWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBTIN * tin = [[WKBTIN alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numPolygons = [[reader readInt] intValue];
    
    for(int i = 0; i < numPolygons; i++){
        WKBPolygon * polygon = (WKBPolygon *)[WKBGeometryReader readGeometryWithReader:reader andExpectedType:[WKBPolygon class]];
        [tin addPolygon:polygon];
    }
    
    return tin;
}

+(WKBTriangle *) readTriangleWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBTriangle * triangle = [[WKBTriangle alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int numRings = [[reader readInt] intValue];
    
    for(int i = 0; i < numRings; i++){
        WKBLineString * ring = [WKBGeometryReader readLineStringWithReader:reader andHasZ:hasZ andHasM:hasM];
        [triangle addRing:ring];
    }
    
    return triangle;
}

@end
