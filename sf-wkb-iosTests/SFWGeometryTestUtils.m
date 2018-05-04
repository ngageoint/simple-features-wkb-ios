//
//  SFWGeometryTestUtils.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import "SFWGeometryTestUtils.h"
#import "SFWTestUtils.h"
#import "SFByteWriter.h"
#import "SFWGeometryWriter.h"
#import "SFByteReader.h"
#import "SFWGeometryReader.h"
#import "SFWGeometryCodes.h"

@implementation SFWGeometryTestUtils

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual{
    
    if(expected == nil){
        [SFWTestUtils assertNil:actual];
    }else{
        [SFWTestUtils assertNotNil:actual];
        
        [SFWTestUtils assertEqualWithValue:expected.minX andValue2:actual.minX];
        [SFWTestUtils assertEqualWithValue:expected.maxX andValue2:actual.maxX];
        [SFWTestUtils assertEqualWithValue:expected.minY andValue2:actual.minY];
        [SFWTestUtils assertEqualWithValue:expected.maxY andValue2:actual.maxY];
        [SFWTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
        [SFWTestUtils assertEqualWithValue:expected.minZ andValue2:actual.minZ];
        [SFWTestUtils assertEqualWithValue:expected.maxZ andValue2:actual.maxZ];
        [SFWTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
        [SFWTestUtils assertEqualWithValue:expected.minM andValue2:actual.minM];
        [SFWTestUtils assertEqualWithValue:expected.maxM andValue2:actual.maxM];
    }
    
}

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    if(expected == nil){
        [SFWTestUtils assertNil:actual];
    }else{
        [SFWTestUtils assertNotNil:actual];
        
        enum SFGeometryType geometryType = expected.geometryType;
        switch(geometryType){
            case SF_GEOMETRY:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POINT:
                [self comparePointWithExpected:(SFPoint *)expected andActual:(SFPoint *)actual];
                break;
            case SF_LINESTRING:
                [self compareLineStringWithExpected:(SFLineString *)expected andActual:(SFLineString *)actual];
                break;
            case SF_POLYGON:
                [self comparePolygonWithExpected:(SFPolygon *)expected andActual:(SFPolygon *)actual];
                break;
            case SF_MULTIPOINT:
                [self compareMultiPointWithExpected:(SFMultiPoint *)expected andActual:(SFMultiPoint *)actual];
                break;
            case SF_MULTILINESTRING:
                [self compareMultiLineStringWithExpected:(SFMultiLineString *)expected andActual:(SFMultiLineString *)actual];
                break;
            case SF_MULTIPOLYGON:
                [self compareMultiPolygonWithExpected:(SFMultiPolygon *)expected andActual:(SFMultiPolygon *)actual];
                break;
            case SF_GEOMETRYCOLLECTION:
                [self compareGeometryCollectionWithExpected:(SFGeometryCollection *)expected andActual:(SFGeometryCollection *)actual];
                break;
            case SF_CIRCULARSTRING:
                [self compareCircularStringWithExpected:(SFCircularString *)expected andActual:(SFCircularString *)actual];
                break;
            case SF_COMPOUNDCURVE:
                [self compareCompoundCurveWithExpected:(SFCompoundCurve *)expected andActual:(SFCompoundCurve *)actual];
                break;
            case SF_CURVEPOLYGON:
                [self compareCurvePolygonWithExpected:(SFCurvePolygon *)expected andActual:(SFCurvePolygon *)actual];
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
                [self comparePolyhedralSurfaceWithExpected:(SFPolyhedralSurface *)expected andActual:(SFPolyhedralSurface *)actual];
                break;
            case SF_TIN:
                [self compareTINWithExpected:(SFTIN *)expected andActual:(SFTIN *)actual];
                break;
            case SF_TRIANGLE:
                [self compareTriangleWithExpected:(SFTriangle *)expected andActual:(SFTriangle *)actual];
                break;
            default:
                [NSException raise:@"Geometry Type Not Supported" format:@"Geometry Type not supported: %d", geometryType];
        }
    }
    
    [SFWTestUtils assertEqualWithValue:expected andValue2:actual];
}

+(void) compareBaseGeometryAttributesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [SFWTestUtils assertEqualIntWithValue:expected.geometryType andValue2:actual.geometryType];
    [SFWTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
    [SFWTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometry:expected] andValue2:[SFWGeometryCodes codeFromGeometry:actual]];
}

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualWithValue:expected.x andValue2:actual.x];
    [SFWTestUtils assertEqualWithValue:expected.y andValue2:actual.y];
    [SFWTestUtils assertEqualWithValue:expected.z andValue2:actual.z];
    [SFWTestUtils assertEqualWithValue:expected.m andValue2:actual.m];
}

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i]];
    }
}

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i]];
    }
}

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[[expected points] objectAtIndex:i] andActual:[[actual points] objectAtIndex:i]];
    }
}

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[[expected lineStrings] objectAtIndex:i] andActual:[[actual lineStrings] objectAtIndex:i]];
    }
}

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self comparePolygonWithExpected:[[expected polygons] objectAtIndex:i] andActual:[[actual polygons] objectAtIndex:i]];
    }
}

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numGeometries] andValue2:[actual numGeometries]];
    for(int i = 0; i < [expected numGeometries]; i++){
        [self compareGeometriesWithExpected:[expected.geometries objectAtIndex:i] andActual:[actual.geometries objectAtIndex:i]];
    }
}

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i]];
    }
}

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i]];
    }
}

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareGeometriesWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i]];
    }
}

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i]];
    }
}

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i]];
    }
}

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i]];
    }
}

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [self compareGeometryDataWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    NSData * expectedData = [self writeDataWithGeometry:expected andByteOrder:byteOrder];
    NSData * actualData = [self writeDataWithGeometry:actual andByteOrder:byteOrder];
    
    [self compareDataWithExpected:expectedData andActual:actualData];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual{
    [self compareDataGeometriesWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    SFGeometry * expectedGeometry = [self readGeometryWithData:expected andByteOrder:byteOrder];
    SFGeometry * actualGeometry = [self readGeometryWithData:actual andByteOrder:byteOrder];
    
    [self compareGeometriesWithExpected:expectedGeometry andActual:actualGeometry];
}

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry{
    return [self writeDataWithGeometry:geometry andByteOrder:CFByteOrderBigEndian];
}

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry andByteOrder: (CFByteOrder) byteOrder{
    SFByteWriter * writer = [[SFByteWriter alloc] init];
    [writer setByteOrder:byteOrder];
    [SFWGeometryWriter writeGeometry:geometry withWriter:writer];
    NSData * data = [writer getData];
    [writer close];
    return data;
}

+(SFGeometry *) readGeometryWithData: (NSData *) data{
    return [self readGeometryWithData:data andByteOrder:CFByteOrderBigEndian];
}

+(SFGeometry *) readGeometryWithData: (NSData *) data andByteOrder: (CFByteOrder) byteOrder{
    SFByteReader * reader = [[SFByteReader alloc] initWithData:data];
    [reader setByteOrder:byteOrder];
    SFGeometry * geometry = [SFWGeometryReader readGeometryWithReader:reader];
    return geometry;
}

+(void) compareDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    
    [SFWTestUtils assertTrue:([expected length] == [actual length])];
    
    [SFWTestUtils assertTrue: [expected isEqualToData:actual]];
    
}

+(BOOL) equalDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    
    return [expected length] == [actual length] && [expected isEqualToData:actual];

}

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [SFWTestUtils randomDoubleLessThan:180.0] * ([SFWTestUtils randomDouble] < .5 ? 1 : -1);
    double y = [SFWTestUtils randomDoubleLessThan:90.0] * ([SFWTestUtils randomDouble] < .5 ? 1 : -1);
    
    NSDecimalNumber * xNumber = [SFWTestUtils roundDouble:x];
    NSDecimalNumber * yNumber = [SFWTestUtils roundDouble:y];
    
    SFPoint * point = [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:xNumber andY:yNumber];
    
    if(hasZ){
        double z = [SFWTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber * zNumber = [SFWTestUtils roundDouble:z];
        [point setZ:zNumber];
    }
    
    if(hasM){
        double m = [SFWTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber * mNumber = [SFWTestUtils roundDouble:m];
        [point setM:mNumber];
    }
    
    return point;
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createLineStringWithHasZ:hasZ andHasM:hasM andRing:false];
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFLineString * lineString = [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWTestUtils randomIntLessThan:9];
    
    for(int i = 0; i < num; i++){
        [lineString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(ring){
        [lineString addPoint:[lineString.points objectAtIndex:0]];
    }
    
    return lineString;
}

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon * polygon = [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [polygon addRing:[self createLineStringWithHasZ:hasZ andHasM:hasM andRing:true]];
    }
    
    return polygon;
}

+(SFMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint * multiPoint = [[SFMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPoint addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPoint;
}

+(SFMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString * multiLineString = [[SFMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiLineString addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon * multiPolygon = [[SFMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPolygon addPolygon:[self createPolygonWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection * geometryCollection = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        
        SFGeometry * geometry = nil;
        int randomGeometry =[SFWTestUtils randomIntLessThan:6];
        
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
    
    SFCompoundCurve *compoundCurve = [[SFCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWTestUtils randomIntLessThan:9];
    
    for (int i = 0; i < num; i++) {
        [compoundCurve addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    if (ring) {
        [[compoundCurve lineStringAtIndex:num-1] addPoint:[[compoundCurve lineStringAtIndex:0] startPoint]];
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) createCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = [[SFCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        [curvePolygon addRing:[self createCompoundCurveWithHasZ:hasZ andHasM:hasM andRing:YES]];
    }
    
    return curvePolygon;
}

+(SFGeometryCollection *) createMultiCurve{
    
    SFGeometryCollection *multiCurve = [[SFGeometryCollection alloc] init];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiCurve addGeometry:[self createCompoundCurveWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]]];
        } else {
            [multiCurve addGeometry:[self createLineStringWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]]];
        }
    }
    
    return multiCurve;
}

+(SFGeometryCollection *) createMultiSurface{
    
    SFGeometryCollection *multiSurface = [[SFGeometryCollection alloc] init];
    
    int num = 1 + [SFWTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiSurface addGeometry:[self createCurvePolygonWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]]];
        } else {
            [multiSurface addGeometry:[self createPolygonWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]]];
        }
    }
    
    return multiSurface;
}

@end
