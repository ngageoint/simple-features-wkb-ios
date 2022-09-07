//
//  SFWBGeometryTestUtils.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import "SFWBGeometryTestUtils.h"
#import "SFWBTestUtils.h"
#import "SFByteWriter.h"
#import "SFWBGeometryWriter.h"
#import "SFByteReader.h"
#import "SFWBGeometryReader.h"
#import "SFWBGeometryCodes.h"

@implementation SFWBGeometryTestUtils

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual{
    [self compareEnvelopesWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual andDelta: (double) delta{
    
    if(expected == nil){
        [SFWBTestUtils assertNil:actual];
    }else{
        [SFWBTestUtils assertNotNil:actual];
        
        [SFWBTestUtils assertEqualDoubleWithValue:[expected.minX doubleValue] andValue2:[actual.minX doubleValue] andDelta:delta];
        [SFWBTestUtils assertEqualDoubleWithValue:[expected.maxX doubleValue] andValue2:[actual.maxX doubleValue] andDelta:delta];
        [SFWBTestUtils assertEqualDoubleWithValue:[expected.minY doubleValue] andValue2:[actual.minY doubleValue] andDelta:delta];
        [SFWBTestUtils assertEqualDoubleWithValue:[expected.maxY doubleValue] andValue2:[actual.maxY doubleValue] andDelta:delta];
        [SFWBTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
        if(expected.hasZ){
            [SFWBTestUtils assertEqualDoubleWithValue:[expected.minZ doubleValue] andValue2:[actual.minZ doubleValue] andDelta:delta];
            [SFWBTestUtils assertEqualDoubleWithValue:[expected.maxZ doubleValue] andValue2:[actual.maxZ doubleValue] andDelta:delta];
        }else{
            [SFWBTestUtils assertNil:expected.minZ];
            [SFWBTestUtils assertNil:expected.maxZ];
            [SFWBTestUtils assertNil:actual.minZ];
            [SFWBTestUtils assertNil:actual.maxZ];
        }
        [SFWBTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
        if(expected.hasM){
            [SFWBTestUtils assertEqualDoubleWithValue:[expected.minM doubleValue] andValue2:[actual.minM doubleValue] andDelta:delta];
            [SFWBTestUtils assertEqualDoubleWithValue:[expected.maxM doubleValue] andValue2:[actual.maxM doubleValue] andDelta:delta];
        }else{
            [SFWBTestUtils assertNil:expected.minM];
            [SFWBTestUtils assertNil:expected.maxM];
            [SFWBTestUtils assertNil:actual.minM];
            [SFWBTestUtils assertNil:actual.maxM];
        }
    }
    
}

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [self compareGeometriesWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andDelta: (double) delta{
    if(expected == nil){
        [SFWBTestUtils assertNil:actual];
    }else{
        [SFWBTestUtils assertNotNil:actual];
        
        enum SFGeometryType geometryType = expected.geometryType;
        switch(geometryType){
            case SF_GEOMETRY:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POINT:
                [self comparePointWithExpected:(SFPoint *)expected andActual:(SFPoint *)actual andDelta:delta];
                break;
            case SF_LINESTRING:
                [self compareLineStringWithExpected:(SFLineString *)expected andActual:(SFLineString *)actual andDelta:delta];
                break;
            case SF_POLYGON:
                [self comparePolygonWithExpected:(SFPolygon *)expected andActual:(SFPolygon *)actual andDelta:delta];
                break;
            case SF_MULTIPOINT:
                [self compareMultiPointWithExpected:(SFMultiPoint *)expected andActual:(SFMultiPoint *)actual andDelta:delta];
                break;
            case SF_MULTILINESTRING:
                [self compareMultiLineStringWithExpected:(SFMultiLineString *)expected andActual:(SFMultiLineString *)actual andDelta:delta];
                break;
            case SF_MULTIPOLYGON:
                [self compareMultiPolygonWithExpected:(SFMultiPolygon *)expected andActual:(SFMultiPolygon *)actual andDelta:delta];
                break;
            case SF_GEOMETRYCOLLECTION:
                [self compareGeometryCollectionWithExpected:(SFGeometryCollection *)expected andActual:(SFGeometryCollection *)actual andDelta:delta];
                break;
            case SF_CIRCULARSTRING:
                [self compareCircularStringWithExpected:(SFCircularString *)expected andActual:(SFCircularString *)actual andDelta:delta];
                break;
            case SF_COMPOUNDCURVE:
                [self compareCompoundCurveWithExpected:(SFCompoundCurve *)expected andActual:(SFCompoundCurve *)actual andDelta:delta];
                break;
            case SF_CURVEPOLYGON:
                [self compareCurvePolygonWithExpected:(SFCurvePolygon *)expected andActual:(SFCurvePolygon *)actual andDelta:delta];
                break;
            case SF_MULTICURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_MULTISURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_CURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_SURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_POLYHEDRALSURFACE:
                [self comparePolyhedralSurfaceWithExpected:(SFPolyhedralSurface *)expected andActual:(SFPolyhedralSurface *)actual andDelta:delta];
                break;
            case SF_TIN:
                [self compareTINWithExpected:(SFTIN *)expected andActual:(SFTIN *)actual andDelta:delta];
                break;
            case SF_TRIANGLE:
                [self compareTriangleWithExpected:(SFTriangle *)expected andActual:(SFTriangle *)actual andDelta:delta];
                break;
            default:
                [NSException raise:@"Geometry Type Not Supported" format:@"Geometry Type not supported: %d", geometryType];
        }
    }
    
    //[SFWBTestUtils assertEqualWithValue:expected andValue2:actual];
}

+(void) compareBaseGeometryAttributesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [SFWBTestUtils assertEqualIntWithValue:expected.geometryType andValue2:actual.geometryType];
    [SFWBTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
    [SFWBTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
    [SFWBTestUtils assertEqualIntWithValue:[SFWBGeometryCodes codeFromGeometry:expected] andValue2:[SFWBGeometryCodes codeFromGeometry:actual]];
}

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual{
    [self comparePointWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualDoubleWithValue:[expected.x doubleValue] andValue2:[actual.x doubleValue] andDelta:delta];
    [SFWBTestUtils assertEqualDoubleWithValue:[expected.y doubleValue] andValue2:[actual.y doubleValue] andDelta:delta];
    [SFWBTestUtils assertEqualDoubleWithValue:[expected.z doubleValue] andValue2:[actual.z doubleValue] andDelta:delta];
    [SFWBTestUtils assertEqualDoubleWithValue:[expected.m doubleValue] andValue2:[actual.m doubleValue] andDelta:delta];
}

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual{
    [self compareLineStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i] andDelta:delta];
    }
}

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual{
    [self comparePolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual{
    [self compareMultiPointWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[[expected points] objectAtIndex:i] andActual:[[actual points] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual{
    [self compareMultiLineStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[[expected lineStrings] objectAtIndex:i] andActual:[[actual lineStrings] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual{
    [self compareMultiPolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self comparePolygonWithExpected:[[expected polygons] objectAtIndex:i] andActual:[[actual polygons] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual{
    [self compareGeometryCollectionWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numGeometries] andValue2:[actual numGeometries]];
    for(int i = 0; i < [expected numGeometries]; i++){
        [self compareGeometriesWithExpected:[expected.geometries objectAtIndex:i] andActual:[actual.geometries objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual{
    [self compareCircularStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual{
    [self compareCompoundCurveWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual{
    [self compareCurvePolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareGeometriesWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i] andDelta:delta];
    }
}

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual{
    [self comparePolyhedralSurfaceWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual{
    [self compareTINWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual{
    [self compareTriangleWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWBTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [self compareGeometryDataWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    NSData *expectedData = [self writeDataWithGeometry:expected andByteOrder:byteOrder];
    NSData *actualData = [self writeDataWithGeometry:actual andByteOrder:byteOrder];
    
    [self compareDataWithExpected:expectedData andActual:actualData];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual{
    [self compareDataGeometriesWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    SFGeometry *expectedGeometry = [self readGeometryWithData:expected andByteOrder:byteOrder];
    SFGeometry *actualGeometry = [self readGeometryWithData:actual andByteOrder:byteOrder];
    
    [self compareGeometriesWithExpected:expectedGeometry andActual:actualGeometry];
}

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry{
    return [self writeDataWithGeometry:geometry andByteOrder:CFByteOrderBigEndian];
}

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry andByteOrder: (CFByteOrder) byteOrder{
    return [SFWBGeometryWriter writeGeometry:geometry inByteOrder:byteOrder];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data{
    return [self readGeometryWithData:data andByteOrder:CFByteOrderBigEndian];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data andByteOrder: (CFByteOrder) byteOrder{
    SFByteReader *reader = [[SFByteReader alloc] initWithData:data andByteOrder:byteOrder];
    SFGeometry *geometry = [SFWBGeometryReader readGeometryWithReader:reader];
    return geometry;
}

+(void) compareDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    
    [SFWBTestUtils assertTrue:([expected length] == [actual length])];
    
    [SFWBTestUtils assertTrue: [expected isEqualToData:actual]];
    
}

+(BOOL) equalDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    return [expected length] == [actual length] && [expected isEqualToData:actual];
}

+(void) compareDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta{
    [self compareDataDoubleComparisonsWithExpected:expected andActual:actual andDelta:delta andByteOrder:CFByteOrderBigEndian];
}

+(void) compareDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder{
    
    [SFWBTestUtils assertTrue:([expected length] == [actual length])];
    
    int nonEqualBytes = [self countNonEqualDataDoubleComparisonsWithExpected:expected andActual:actual andDelta:delta andByteOrder:byteOrder];
    
    [SFWBTestUtils assertEqualIntWithValue:0 andValue2:nonEqualBytes];
}

+(int) countNonEqualDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    [SFWBTestUtils assertEqualIntWithValue:(int)expected.length andValue2:(int)actual.length];
    const char *expectedBytes = [expected bytes];
    const char *actualBytes = [actual bytes];
    return [self countNonEqualBytesWithExpected:expectedBytes andActual:actualBytes andLength:expected.length];
}

+(int) countNonEqualBytesWithExpected: (const char *) expected andActual: (const char *) actual andLength: (NSUInteger) length{
    int nonEqualBytes = 0;
    for (int i = 0; i < length; i++) {
        if (expected[i] != actual[i]) {
            nonEqualBytes++;
        }
    }
    return nonEqualBytes;
}

+(int) countNonEqualDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta{
    return [self countNonEqualDataDoubleComparisonsWithExpected:expected andActual:actual andDelta:delta andByteOrder:CFByteOrderBigEndian];
}

+(int) countNonEqualDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder{
    [SFWBTestUtils assertEqualIntWithValue:(int)expected.length andValue2:(int)actual.length];
    const char *expectedBytes = [expected bytes];
    const char *actualBytes = [actual bytes];
    return [self countNonEqualBytesDoubleComparisonsWithExpected:expectedBytes andActual:actualBytes andLength:expected.length andDelta:delta andByteOrder:byteOrder];
}

+(int) countNonEqualBytesDoubleComparisonsWithExpected: (const char *) expected andActual: (const char *) actual andLength: (NSUInteger) length andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder{
    
    int nonEqualBytes = 0;

    for(int i = 0; i < length; i++){
        
        int expectedByte = (int) expected[i];
        int actualByte = (int) actual[i];
        
        if(expectedByte != actualByte){
            int startIndex;
            if(byteOrder == CFByteOrderBigEndian){
                startIndex = i-7;
            }else{
                startIndex = i;
            }
            NSData *data1 = [[NSData alloc] initWithBytes:&expected[startIndex] length:8];
            NSData *data2 = [[NSData alloc] initWithBytes:&actual[startIndex] length:8];
            SFByteReader *byteReader1 = [[SFByteReader alloc] initWithData:data1 andByteOrder:byteOrder];
            SFByteReader *byteReader2 = [[SFByteReader alloc] initWithData:data2 andByteOrder:byteOrder];
            NSDecimalNumber *decimalNumber1 = [byteReader1 readDouble];
            NSDecimalNumber *decimalNumber2 = [byteReader2 readDouble];
            double double1 = [decimalNumber1 doubleValue];
            double double2 = [decimalNumber2 doubleValue];
            if(fabsl(double1 - double2) > delta){
                nonEqualBytes++;
            }
        }
        
    }
    
    return nonEqualBytes;
}

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [SFWBTestUtils randomDoubleLessThan:180.0] * ([SFWBTestUtils randomDouble] < .5 ? 1 : -1);
    double y = [SFWBTestUtils randomDoubleLessThan:90.0] * ([SFWBTestUtils randomDouble] < .5 ? 1 : -1);
    
    NSDecimalNumber *xNumber = [SFWBTestUtils roundDouble:x];
    NSDecimalNumber *yNumber = [SFWBTestUtils roundDouble:y];
    
    SFPoint *point = [SFPoint pointWithHasZ:hasZ andHasM:hasM andX:xNumber andY:yNumber];
    
    if(hasZ){
        double z = [SFWBTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber *zNumber = [SFWBTestUtils roundDouble:z];
        [point setZ:zNumber];
    }
    
    if(hasM){
        double m = [SFWBTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber *mNumber = [SFWBTestUtils roundDouble:m];
        [point setM:mNumber];
    }
    
    return point;
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createLineStringWithHasZ:hasZ andHasM:hasM andRing:false];
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFLineString *lineString = [SFLineString lineStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWBTestUtils randomIntLessThan:9];
    
    for(int i = 0; i < num; i++){
        [lineString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(ring){
        [lineString addPoint:[lineString.points objectAtIndex:0]];
    }
    
    return lineString;
}

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon *polygon = [SFPolygon polygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [polygon addRing:[self createLineStringWithHasZ:hasZ andHasM:hasM andRing:true]];
    }
    
    return polygon;
}

+(SFMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = [SFMultiPoint multiPointWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPoint addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPoint;
}

+(SFMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = [SFMultiLineString multiLineStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiLineString addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = [SFMultiPolygon multiPolygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPolygon addPolygon:[self createPolygonWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        
        SFGeometry *geometry = nil;
        int randomGeometry =[SFWBTestUtils randomIntLessThan:6];
        
        switch(randomGeometry){
            case 0:
                geometry = [self createPointWithHasZ:hasZ andHasM:hasM];
                break;
            case 1:
                geometry = [self createLineStringWithHasZ:hasZ andHasM:hasM];
                break;
            case 2:
                geometry = [self createPolygonWithHasZ:hasZ andHasM:hasM];
                break;
            case 3:
                geometry = [self createMultiPointWithHasZ:hasZ andHasM:hasM];
                break;
            case 4:
                geometry = [self createMultiLineStringWithHasZ:hasZ andHasM:hasM];
                break;
            case 5:
                geometry = [self createMultiPolygonWithHasZ:hasZ andHasM:hasM];
                break;
        }
        
        [geometryCollection addGeometry:geometry];
    }
    
    return geometryCollection;
}

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createCompoundCurveWithHasZ:hasZ andHasM:hasM andRing:NO];
}

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFCompoundCurve *compoundCurve = [SFCompoundCurve compoundCurveWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWBTestUtils randomIntLessThan:9];
    
    for (int i = 0; i < num; i++) {
        [compoundCurve addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    if (ring) {
        [[compoundCurve lineStringAtIndex:num-1] addPoint:[[compoundCurve lineStringAtIndex:0] startPoint]];
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) createCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = [SFCurvePolygon curvePolygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        [curvePolygon addRing:[self createCompoundCurveWithHasZ:hasZ andHasM:hasM andRing:YES]];
    }
    
    return curvePolygon;
}

+(SFGeometryCollection *) createMultiCurve{
    
    SFGeometryCollection *multiCurve = [SFGeometryCollection geometryCollection];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiCurve addGeometry:[self createCompoundCurveWithHasZ:[SFWBTestUtils coinFlip] andHasM:[SFWBTestUtils coinFlip]]];
        } else {
            [multiCurve addGeometry:[self createLineStringWithHasZ:[SFWBTestUtils coinFlip] andHasM:[SFWBTestUtils coinFlip]]];
        }
    }
    
    return multiCurve;
}

+(SFGeometryCollection *) createMultiSurface{
    
    SFGeometryCollection *multiSurface = [SFGeometryCollection geometryCollection];
    
    int num = 1 + [SFWBTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiSurface addGeometry:[self createCurvePolygonWithHasZ:[SFWBTestUtils coinFlip] andHasM:[SFWBTestUtils coinFlip]]];
        } else {
            [multiSurface addGeometry:[self createPolygonWithHasZ:[SFWBTestUtils coinFlip] andHasM:[SFWBTestUtils coinFlip]]];
        }
    }
    
    return multiSurface;
}

@end
