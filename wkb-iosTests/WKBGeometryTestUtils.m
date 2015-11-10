//
//  WKBGeometryTestUtils.m
//  wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import "WKBGeometryTestUtils.h"
#import "WKBTestUtils.h"
#import "WKBByteWriter.h"
#import "WKBGeometryWriter.h"
#import "WKBByteReader.h"
#import "WKBGeometryReader.h"

@implementation WKBGeometryTestUtils

+(void) compareEnvelopesWithExpected: (WKBGeometryEnvelope *) expected andActual: (WKBGeometryEnvelope *) actual{
    
    if(expected == nil){
        [WKBTestUtils assertNil:actual];
    }else{
        [WKBTestUtils assertNotNil:actual];
        
        [WKBTestUtils assertEqualWithValue:expected.minX andValue2:actual.minX];
        [WKBTestUtils assertEqualWithValue:expected.maxX andValue2:actual.maxX];
        [WKBTestUtils assertEqualWithValue:expected.minY andValue2:actual.minY];
        [WKBTestUtils assertEqualWithValue:expected.maxY andValue2:actual.maxY];
        [WKBTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
        [WKBTestUtils assertEqualWithValue:expected.minZ andValue2:actual.minZ];
        [WKBTestUtils assertEqualWithValue:expected.maxZ andValue2:actual.maxZ];
        [WKBTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
        [WKBTestUtils assertEqualWithValue:expected.minM andValue2:actual.minM];
        [WKBTestUtils assertEqualWithValue:expected.maxM andValue2:actual.maxM];
    }
    
}

+(void) compareGeometriesWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual{
    if(expected == nil){
        [WKBTestUtils assertNil:actual];
    }else{
        [WKBTestUtils assertNotNil:actual];
        
        enum WKBGeometryType geometryType = expected.geometryType;
        switch(geometryType){
            case WKB_GEOMETRY:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
            case WKB_POINT:
                [self comparePointWithExpected:(WKBPoint *)expected andActual:(WKBPoint *)actual];
                break;
            case WKB_LINESTRING:
                [self compareLineStringWithExpected:(WKBLineString *)expected andActual:(WKBLineString *)actual];
                break;
            case WKB_POLYGON:
                [self comparePolygonWithExpected:(WKBPolygon *)expected andActual:(WKBPolygon *)actual];
                break;
            case WKB_MULTIPOINT:
                [self compareMultiPointWithExpected:(WKBMultiPoint *)expected andActual:(WKBMultiPoint *)actual];
                break;
            case WKB_MULTILINESTRING:
                [self compareMultiLineStringWithExpected:(WKBMultiLineString *)expected andActual:(WKBMultiLineString *)actual];
                break;
            case WKB_MULTIPOLYGON:
                [self compareMultiPolygonWithExpected:(WKBMultiPolygon *)expected andActual:(WKBMultiPolygon *)actual];
                break;
            case WKB_GEOMETRYCOLLECTION:
                [self compareGeometryCollectionWithExpected:(WKBGeometryCollection *)expected andActual:(WKBGeometryCollection *)actual];
                break;
            case WKB_CIRCULARSTRING:
                [self compareCircularStringWithExpected:(WKBCircularString *)expected andActual:(WKBCircularString *)actual];
                break;
            case WKB_COMPOUNDCURVE:
                [self compareCompoundCurveWithExpected:(WKBCompoundCurve *)expected andActual:(WKBCompoundCurve *)actual];
                break;
            case WKB_CURVEPOLYGON:
                [self compareCurvePolygonWithExpected:(WKBCurvePolygon *)expected andActual:(WKBCurvePolygon *)actual];
                break;
            case WKB_MULTICURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
                break;
            case WKB_MULTISURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
                break;
            case WKB_CURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
                break;
            case WKB_SURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [WKBGeometryTypes name:geometryType]];
                break;
            case WKB_POLYHEDRALSURFACE:
                [self comparePolyhedralSurfaceWithExpected:(WKBPolyhedralSurface *)expected andActual:(WKBPolyhedralSurface *)actual];
                break;
            case WKB_TIN:
                [self compareTINWithExpected:(WKBTIN *)expected andActual:(WKBTIN *)actual];
                break;
            case WKB_TRIANGLE:
                [self compareTriangleWithExpected:(WKBTriangle *)expected andActual:(WKBTriangle *)actual];
                break;
            default:
                [NSException raise:@"Geometry Type Not Supported" format:@"Geometry Type not supported: %d", geometryType];
        }
    }
}

+(void) compareBaseGeometryAttributesWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual{
    [WKBTestUtils assertEqualIntWithValue:expected.geometryType andValue2:actual.geometryType];
    [WKBTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
    [WKBTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
    [WKBTestUtils assertEqualIntWithValue:[expected getWkbCode] andValue2:[actual getWkbCode]];
}

+(void) comparePointWithExpected: (WKBPoint *) expected andActual: (WKBPoint *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:expected.x andValue2:actual.x];
    [WKBTestUtils assertEqualWithValue:expected.y andValue2:actual.y];
    [WKBTestUtils assertEqualWithValue:expected.z andValue2:actual.z];
    [WKBTestUtils assertEqualWithValue:expected.m andValue2:actual.m];
}

+(void) compareLineStringWithExpected: (WKBLineString *) expected andActual: (WKBLineString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [[expected numPoints] intValue]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i]];
    }
}

+(void) comparePolygonWithExpected: (WKBPolygon *) expected andActual: (WKBPolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [[expected numRings] intValue]; i++){
        [self compareLineStringWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i]];
    }
}

+(void) compareMultiPointWithExpected: (WKBMultiPoint *) expected andActual: (WKBMultiPoint *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [[expected numPoints] intValue]; i++){
        [self comparePointWithExpected:[[expected getPoints] objectAtIndex:i] andActual:[[actual getPoints] objectAtIndex:i]];
    }
}

+(void) compareMultiLineStringWithExpected: (WKBMultiLineString *) expected andActual: (WKBMultiLineString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [[expected numLineStrings] intValue]; i++){
        [self compareLineStringWithExpected:[[expected getLineStrings] objectAtIndex:i] andActual:[[actual getLineStrings] objectAtIndex:i]];
    }
}

+(void) compareMultiPolygonWithExpected: (WKBMultiPolygon *) expected andActual: (WKBMultiPolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [[expected numPolygons] intValue]; i++){
        [self comparePolygonWithExpected:[[expected getPolygons] objectAtIndex:i] andActual:[[actual getPolygons] objectAtIndex:i]];
    }
}

+(void) compareGeometryCollectionWithExpected: (WKBGeometryCollection *) expected andActual: (WKBGeometryCollection *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numGeometries] andValue2:[actual numGeometries]];
    for(int i = 0; i < [[expected numGeometries] intValue]; i++){
        [self compareGeometriesWithExpected:[expected.geometries objectAtIndex:i] andActual:[actual.geometries objectAtIndex:i]];
    }
}

+(void) compareCircularStringWithExpected: (WKBCircularString *) expected andActual: (WKBCircularString *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [[expected numPoints] intValue]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i]];
    }
}

+(void) compareCompoundCurveWithExpected: (WKBCompoundCurve *) expected andActual: (WKBCompoundCurve *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [[expected numLineStrings] intValue]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i]];
    }
}

+(void) compareCurvePolygonWithExpected: (WKBCurvePolygon *) expected andActual: (WKBCurvePolygon *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [[expected numRings] intValue]; i++){
        [self compareGeometriesWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i]];
    }
}

+(void) comparePolyhedralSurfaceWithExpected: (WKBPolyhedralSurface *) expected andActual: (WKBPolyhedralSurface *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [[expected numPolygons] intValue]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i]];
    }
}

+(void) compareTINWithExpected: (WKBTIN *) expected andActual: (WKBTIN *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [[expected numPolygons] intValue]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i]];
    }
}

+(void) compareTriangleWithExpected: (WKBTriangle *) expected andActual: (WKBTriangle *) actual{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [WKBTestUtils assertEqualWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [[expected numRings] intValue]; i++){
        [self compareLineStringWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i]];
    }
}

+(void) compareGeometryDataWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual{
    [self compareGeometryDataWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareGeometryDataWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    NSData * expectedData = [self writeDataWithGeometry:expected andByteOrder:byteOrder];
    NSData * actualData = [self writeDataWithGeometry:actual andByteOrder:byteOrder];
    
    [self compareDataWithExpected:expectedData andActual:actualData];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual{
    [self compareDataGeometriesWithExpected:expected andActual:actual andByteOrder:CFByteOrderBigEndian];
}

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual andByteOrder: (CFByteOrder) byteOrder{
    
    WKBGeometry * expectedGeometry = [self readGeometryWithData:expected andByteOrder:byteOrder];
    WKBGeometry * actualGeometry = [self readGeometryWithData:actual andByteOrder:byteOrder];
    
    [self compareGeometriesWithExpected:expectedGeometry andActual:actualGeometry];
}

+(NSData *) writeDataWithGeometry: (WKBGeometry *) geometry{
    return [self writeDataWithGeometry:geometry andByteOrder:CFByteOrderBigEndian];
}

+(NSData *) writeDataWithGeometry: (WKBGeometry *) geometry andByteOrder: (CFByteOrder) byteOrder{
    WKBByteWriter * writer = [[WKBByteWriter alloc] init];
    [writer setByteOrder:byteOrder];
    [WKBGeometryWriter writeGeometry:geometry withWriter:writer];
    NSData * data = [writer getData];
    [writer close];
    return data;
}

+(WKBGeometry *) readGeometryWithData: (NSData *) data{
    return [self readGeometryWithData:data andByteOrder:CFByteOrderBigEndian];
}

+(WKBGeometry *) readGeometryWithData: (NSData *) data andByteOrder: (CFByteOrder) byteOrder{
    WKBByteReader * reader = [[WKBByteReader alloc] initWithData:data];
    [reader setByteOrder:byteOrder];
    WKBGeometry * geometry = [WKBGeometryReader readGeometryWithReader:reader];
    return geometry;
}

+(void) compareDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    
    [WKBTestUtils assertTrue:([expected length] == [actual length])];
    
    [WKBTestUtils assertTrue: [expected isEqualToData:actual]];
    
}

+(BOOL) equalDataWithExpected: (NSData *) expected andActual: (NSData *) actual{
    
    return [expected length] == [actual length] && [expected isEqualToData:actual];

}

+(WKBPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [WKBTestUtils randomDoubleLessThan:180.0] * ([WKBTestUtils randomDouble] < .5 ? 1 : -1);
    double y = [WKBTestUtils randomDoubleLessThan:90.0] * ([WKBTestUtils randomDouble] < .5 ? 1 : -1);
    
    NSDecimalNumber * xNumber = [WKBTestUtils roundDouble:x];
    NSDecimalNumber * yNumber = [WKBTestUtils roundDouble:y];
    
    WKBPoint * point = [[WKBPoint alloc] initWithHasZ:hasZ andHasM:hasM andX:xNumber andY:yNumber];
    
    if(hasZ){
        double z = [WKBTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber * zNumber = [WKBTestUtils roundDouble:z];
        [point setZ:zNumber];
    }
    
    if(hasM){
        double m = [WKBTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber * mNumber = [WKBTestUtils roundDouble:m];
        [point setM:mNumber];
    }
    
    return point;
}

+(WKBLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createLineStringWithHasZ:hasZ andHasM:hasM andRing:false];
}

+(WKBLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    WKBLineString * lineString = [[WKBLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [WKBTestUtils randomIntLessThan:9];
    
    for(int i = 0; i < num; i++){
        [lineString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(ring){
        [lineString addPoint:[lineString.points objectAtIndex:0]];
    }
    
    return lineString;
}

+(WKBPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBPolygon * polygon = [[WKBPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [WKBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [polygon addRing:[self createLineStringWithHasZ:hasZ andHasM:hasM andRing:true]];
    }
    
    return polygon;
}

+(WKBMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiPoint * multiPoint = [[WKBMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [WKBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPoint addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPoint;
}

+(WKBMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiLineString * multiLineString = [[WKBMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [WKBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiLineString addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiLineString;
}

+(WKBMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBMultiPolygon * multiPolygon = [[WKBMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [WKBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPolygon addPolygon:[self createPolygonWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPolygon;
}

+(WKBGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    WKBGeometryCollection * geometryCollection = [[WKBGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [WKBTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        
        WKBGeometry * geometry = nil;
        int randomGeometry =[WKBTestUtils randomIntLessThan:6];
        
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

@end
