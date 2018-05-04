//
//  SFWTestCase.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFWTestUtils.h"
#import "SFWGeometryTestUtils.h"
#import "SFGeometryEnvelopeBuilder.h"
#import "SFWGeometryCodes.h"
#import "SFExtendedGeometryCollection.h"

@interface SFWTestCase : XCTestCase

@end

@implementation SFWTestCase

static NSUInteger GEOMETRIES_PER_TEST = 10;

-(void) setUp {
    [super setUp];
}

-(void) tearDown {
    [super tearDown];
}

-(void) testPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a point
        SFPoint * point = [SFWGeometryTestUtils createPointWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: point];
    }
}

-(void) testLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a line string
        SFLineString * lineString = [SFWGeometryTestUtils createLineStringWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: lineString];
    }
}

-(void) testPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a polygon
        SFPolygon * polygon = [SFWGeometryTestUtils createPolygonWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: polygon];
    }
}

-(void) testMultiPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi point
        SFMultiPoint * multiPoint = [SFWGeometryTestUtils createMultiPointWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: multiPoint];
    }
}

-(void) testMultiLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi line string
        SFMultiLineString * multiLineString = [SFWGeometryTestUtils createMultiLineStringWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: multiLineString];
    }
}

-(void) testMultiCurveWithLineStrings{

    // Test a pre-created WKB saved as the abstract MultiCurve type with
    // LineStrings
    
    const char bytes[] = { 0, 0, 0, 0, 11, 0, 0, 0, 2, 0, 0, 0, 0, 2,
        0, 0, 0, 3, 64, 50, -29, -55, -6, 126, -15, 120, -64, 65, -124,
        -86, -46, -62, -60, 94, -64, 66, -31, -40, 124, -2, -47, -5,
        -64, 82, -13, -22, 8, -38, 6, 111, 64, 81, 58, 88, 78, -15, 82,
        111, -64, 86, 20, -18, -37, 3, -99, -86, 0, 0, 0, 0, 2, 0, 0,
        0, 10, 64, 98, 48, -84, 37, -62, 34, 98, -64, 68, -12, -81,
        104, 13, -109, 6, -64, 101, -82, 76, -68, 34, 117, -110, 64,
        39, -125, 83, 1, 50, 86, 8, -64, 83, 127, -93, 42, -89, 54,
        -56, -64, 67, -58, -13, -104, 1, -17, -10, 64, 97, 18, -82,
        -112, 100, -128, 16, 64, 68, -13, -86, -112, 112, 59, -3, 64,
        67, -4, -71, -91, -16, -15, 85, -64, 49, 110, -16, 94, -71, 24,
        -13, -64, 94, 84, 94, -4, -78, -101, -75, -64, 80, 74, -39, 90,
        38, 107, 104, 64, 72, -16, -43, 82, -112, -39, 77, 64, 28, 30,
        97, -26, 64, 102, -110, 64, 92, 63, -14, -103, 99, -67, 63,
        -64, 65, -48, 84, -37, -111, -55, -25, -64, 101, -10, -62,
        -115, 104, -125, 28, -64, 66, 5, 108, -56, -59, 69, -36, -64,
        83, 33, -36, -86, 106, -84, -16, 64, 70, 30, -104, -50, -57,
        15, -7 };
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTICURVE] andValue2:bytes[4]];
    
    SFGeometry *geometry = [SFWGeometryTestUtils readGeometryWithData:data];
    [SFWTestUtils assertTrue:[geometry isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertEqualIntWithValue:geometry.geometryType andValue2:SF_GEOMETRYCOLLECTION];
    SFGeometryCollection *multiCurve = (SFGeometryCollection *) geometry;
    [SFWTestUtils assertEqualIntWithValue:2 andValue2:[multiCurve numGeometries]];
    SFGeometry *geometry1 = [multiCurve geometryAtIndex:0];
    SFGeometry *geometry2 = [multiCurve geometryAtIndex:1];
    [SFWTestUtils assertTrue:[geometry1 isKindOfClass:[SFLineString class]]];
    [SFWTestUtils assertTrue:[geometry2 isKindOfClass:[SFLineString class]]];
    SFLineString *lineString1 = (SFLineString *) geometry1;
    SFLineString *lineString2 = (SFLineString *) geometry2;
    [SFWTestUtils assertEqualIntWithValue:3 andValue2:[lineString1 numPoints]];
    [SFWTestUtils assertEqualIntWithValue:10 andValue2:[lineString2 numPoints]];
    SFPoint *point1 = [lineString1 startPoint];
    SFPoint *point2 = [lineString2 endPoint];
    [SFWTestUtils assertEqualDoubleWithValue:18.889800697319032 andValue2:[point1.x doubleValue] andDelta:0.0000000000001];
    [SFWTestUtils assertEqualDoubleWithValue:-35.036463112927535 andValue2:[point1.y doubleValue] andDelta:0.0000000000001];
    [SFWTestUtils assertEqualDoubleWithValue:-76.52909336488278 andValue2:[point2.x doubleValue] andDelta:0.0000000000001];
    [SFWTestUtils assertEqualDoubleWithValue:44.2390383216843 andValue2:[point2.y doubleValue] andDelta:0.0000000000001];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
// TODO   [self geometryTester:extendedMultiCurve withCompare:multiCurve];
    
    NSData *data2 = [SFWGeometryTestUtils writeDataWithGeometry:extendedMultiCurve];
    const char *bytes2 = [data2 bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTICURVE] andValue2:(int)bytes2[4]];
 // TODO  [SFWGeometryTestUtils compareDataWithExpected:data andActual:data2];
    
}

-(void) testMultiCurveWithCompoundCurve{

    // Test a pre-created WKB saved as the abstract MultiCurve type with a
    // CompoundCurve
    
    const char bytes[] = { 0, 0, 0, 0, 11, 0, 0, 0, 1, 0, 0, 0, 0, 9,
        0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 3, 65, 74, 85, 13, 0, -60,
        -101, -90, 65, 84, -23, 84, 60, -35, 47, 27, 65, 74, 85, 12,
        -28, -68, 106, 127, 65, 84, -23, 84, 123, 83, -9, -49, 65, 74,
        85, 8, -1, 92, 40, -10, 65, 84, -23, 83, -81, -99, -78, 45, 0,
        0, 0, 0, 2, 0, 0, 0, 2, 65, 74, 85, 8, -1, 92, 40, -10, 65, 84,
        -23, 83, -81, -99, -78, 45, 65, 74, 85, 13, 0, -60, -101, -90,
        65, 84, -23, 84, 60, -35, 47, 27 };
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTICURVE] andValue2:bytes[4]];
    
    SFGeometry *geometry = [SFWGeometryTestUtils readGeometryWithData:data];
    [SFWTestUtils assertTrue:[geometry isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertEqualIntWithValue:geometry.geometryType andValue2:SF_GEOMETRYCOLLECTION];
    SFGeometryCollection *multiCurve = (SFGeometryCollection *) geometry;
    [SFWTestUtils assertEqualIntWithValue:1 andValue2:[multiCurve numGeometries]];
    SFGeometry *geometry1 = [multiCurve geometryAtIndex:0];
    [SFWTestUtils assertTrue:[geometry1 isKindOfClass:[SFCompoundCurve class]]];
    SFCompoundCurve *compoundCurve1 = (SFCompoundCurve *) geometry1;
    [SFWTestUtils assertEqualIntWithValue:2 andValue2:[compoundCurve1 numLineStrings]];
    SFLineString *lineString1 = [compoundCurve1 lineStringAtIndex:0];
    SFLineString *lineString2 = [compoundCurve1 lineStringAtIndex:1];
    [SFWTestUtils assertEqualIntWithValue:3 andValue2:[lineString1 numPoints]];
    [SFWTestUtils assertEqualIntWithValue:2 andValue2:[lineString2 numPoints]];
    
    [SFWTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451418.006 andYValue:5481808.951] andValue2:[lineString1 pointAtIndex:0]];
    [SFWTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451417.787 andYValue:5481809.927] andValue2:[lineString1 pointAtIndex:1]];
    [SFWTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451409.995 andYValue:5481806.744] andValue2:[lineString1 pointAtIndex:2]];
    
    [SFWTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451409.995 andYValue:5481806.744] andValue2:[lineString2 pointAtIndex:0]];
    [SFWTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451418.006 andYValue:5481808.951] andValue2:[lineString2 pointAtIndex:1]];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
    [self geometryTester:extendedMultiCurve withCompare:multiCurve];
    
    NSData *data2 = [SFWGeometryTestUtils writeDataWithGeometry:extendedMultiCurve];
    const char *bytes2 = [data2 bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTICURVE] andValue2:(int)bytes2[4]];
    // TODO [SFWGeometryTestUtils compareDataWithExpected:data andActual:data2];
}

-(void) testMultiCurve{

    // Test the abstract MultiCurve type
    
    SFGeometryCollection *multiCurve = [SFWGeometryTestUtils createMultiCurve];
    
    NSData *data = [SFWGeometryTestUtils writeDataWithGeometry:multiCurve];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
    NSData *extendedData = [SFWGeometryTestUtils writeDataWithGeometry:extendedMultiCurve];
    
    const char *bytes = [data bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_GEOMETRYCOLLECTION] andValue2:(int)bytes[4]];
    const char *extendedBytes = [extendedData bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTICURVE] andValue2:(int)extendedBytes[4]];
    
    SFGeometry *geometry1 = [SFWGeometryTestUtils readGeometryWithData:data];
    SFGeometry *geometry2 = [SFWGeometryTestUtils readGeometryWithData:extendedData];
    
    [SFWTestUtils assertTrue:[geometry1 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertTrue:[geometry2 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry1.geometryType];
    [SFWTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry2.geometryType];
    
    [SFWTestUtils assertEqualWithValue:multiCurve andValue2:geometry1];
    [SFWTestUtils assertEqualWithValue:geometry1 andValue2:geometry2];
    
    SFGeometryCollection *geometryCollection1 = (SFGeometryCollection *) geometry1;
    SFGeometryCollection *geometryCollection2 = (SFGeometryCollection *) geometry2;
    [SFWTestUtils assertTrue:[geometryCollection1 isMultiCurve]];
    [SFWTestUtils assertTrue:[geometryCollection2 isMultiCurve]];
    
    [self geometryTester:multiCurve];
    [self geometryTester:extendedMultiCurve withCompare:multiCurve];
}

-(void) testMultiSurface{

    // Test the abstract MultiSurface type
    
    SFGeometryCollection *multiSurface = [SFWGeometryTestUtils createMultiSurface];
    
    NSData *data = [SFWGeometryTestUtils writeDataWithGeometry:multiSurface];
    
    SFExtendedGeometryCollection *extendedMultiSurface = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiSurface];
    [SFWTestUtils assertEqualIntWithValue:SF_MULTISURFACE andValue2:extendedMultiSurface.geometryType];
    
    NSData *extendedData = [SFWGeometryTestUtils writeDataWithGeometry:extendedMultiSurface];
    
    const char *bytes = [data bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_GEOMETRYCOLLECTION] andValue2:(int)bytes[4]];
    const char *extendedBytes = [extendedData bytes];
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTISURFACE] andValue2:(int)extendedBytes[4]];
    
    SFGeometry *geometry1 = [SFWGeometryTestUtils readGeometryWithData:data];
    SFGeometry *geometry2 = [SFWGeometryTestUtils readGeometryWithData:extendedData];
    
    [SFWTestUtils assertTrue:[geometry1 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertTrue:[geometry2 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry1.geometryType];
    [SFWTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry2.geometryType];
    
    [SFWTestUtils assertEqualWithValue:multiSurface andValue2:geometry1];
    [SFWTestUtils assertEqualWithValue:geometry1 andValue2:geometry2];
    
    SFGeometryCollection *geometryCollection1 = (SFGeometryCollection *) geometry1;
    SFGeometryCollection *geometryCollection2 = (SFGeometryCollection *) geometry2;
    [SFWTestUtils assertTrue:[geometryCollection1 isMultiSurface]];
    [SFWTestUtils assertTrue:[geometryCollection2 isMultiSurface]];
    
    [self geometryTester:multiSurface];
    [self geometryTester:extendedMultiSurface withCompare:multiSurface];
}

-(void) testMultiPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi polygon
        SFMultiPolygon * multiPolygon = [SFWGeometryTestUtils createMultiPolygonWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: multiPolygon];
    }
}

-(void) testGeometryCollection {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a geometry collection
        SFGeometryCollection * geometryCollection = [SFWGeometryTestUtils createGeometryCollectionWithHasZ:[SFWTestUtils coinFlip] andHasM:[SFWTestUtils coinFlip]];
        [self geometryTester: geometryCollection];
    }
}

-(void) testMultiPolygon25{

    // Test a pre-created WKB hex saved as a 2.5D MultiPolygon
    
    NSData *data = [SFWTestCase hexStringToData:@"0106000080010000000103000080010000000F0000007835454789C456C0DFDB63124D3F2C4000000000000000004CE4512E89C456C060BF20D13F3F2C400000000000000000A42EC6388CC456C0E0A50400423F2C400000000000000000B4E3B1608CC456C060034E67433F2C400000000000000000F82138508DC456C09FD015C5473F2C400000000000000000ECD6591B8CC456C000C305BC5B3F2C4000000000000000001002AD0F8CC456C060DB367D5C3F2C40000000000000000010996DEF8AC456C0BF01756A6C3F2C4000000000000000007054A08B8AC456C0806A0C1F733F2C4000000000000000009422D81D8AC456C041CA3C5B8A3F2C4000000000000000003CCB05C489C456C03FC4FC52AA3F2C400000000000000000740315A689C456C0BFC8635EB33F2C400000000000000000E4A5630B89C456C0DFE726D6B33F2C400000000000000000F45A4F3389C456C000B07950703F2C4000000000000000007835454789C456C0DFDB63124D3F2C400000000000000000"];
    const char *bytes = [data bytes];
    
    [SFWTestUtils assertEqualIntWithValue:1 andValue2:(int)bytes[0]]; // little endian
    [SFWTestUtils assertEqualIntWithValue:[SFWGeometryCodes codeFromGeometryType:SF_MULTIPOLYGON] andValue2:(int)bytes[1]];
    [SFWTestUtils assertEqualIntWithValue:0 andValue2:(int)bytes[2]];
    [SFWTestUtils assertEqualIntWithValue:0 andValue2:(int)bytes[3]];
    [SFWTestUtils assertEqualIntWithValue:-128 andValue2:(int)bytes[4]];
    
    SFGeometry *geometry = [SFWGeometryTestUtils readGeometryWithData:data];
    [SFWTestUtils assertTrue:[geometry isKindOfClass:[SFMultiPolygon class]]];
    [SFWTestUtils assertEqualIntWithValue:SF_MULTIPOLYGON andValue2:geometry.geometryType];
    SFMultiPolygon *multiPolygon = (SFMultiPolygon *) geometry;
    [SFWTestUtils assertTrue:multiPolygon.hasZ];
    [SFWTestUtils assertFalse:multiPolygon.hasM];
    [SFWTestUtils assertEqualIntWithValue:1 andValue2:[multiPolygon numGeometries]];
    SFPolygon *polygon = [multiPolygon polygonAtIndex:0];
    [SFWTestUtils assertTrue:polygon.hasZ];
    [SFWTestUtils assertFalse:polygon.hasM];
    [SFWTestUtils assertEqualIntWithValue:1 andValue2:[polygon numRings]];
    SFLineString *ring = [polygon ringAtIndex:0];
    [SFWTestUtils assertTrue:ring.hasZ];
    [SFWTestUtils assertFalse:ring.hasM];
    [SFWTestUtils assertEqualIntWithValue:15 andValue2:[ring numPoints]];
    for(SFPoint *point in ring.points){
        [SFWTestUtils assertTrue:point.hasZ];
        [SFWTestUtils assertFalse:point.hasM];
        [SFWTestUtils assertNotNil:point.z];
        [SFWTestUtils assertNil:point.m];
    }
    
    NSData *multiPolygonData = [SFWGeometryTestUtils writeDataWithGeometry:multiPolygon andByteOrder:CFByteOrderLittleEndian];
    const char *multiPolygonBytes = [multiPolygonData bytes];
    SFGeometry *geometry2 = [SFWGeometryTestUtils readGeometryWithData:multiPolygonData];
    
    [self geometryTester:geometry withCompare:geometry2];
    
    [SFWTestUtils assertEqualIntWithValue:(int)data.length andValue2:(int)multiPolygonData.length];
    int equalBytes = 0;
    for (int i = 0; i < data.length; i++) {
        if (bytes[i] == multiPolygonBytes[i]) {
            equalBytes++;
        }
    }
    // TODO [SFWTestUtils assertEqualIntWithValue:(int)data.length - 6 andValue2:equalBytes];
}

-(void) geometryTester: (SFGeometry *) geometry{
    [self geometryTester:geometry withCompare:geometry];
}

-(void) geometryTester: (SFGeometry *) geometry withCompare: (SFGeometry *) compareGeometry{
    
    // Write the geometries to bytes
    NSData * data1 = [SFWGeometryTestUtils writeDataWithGeometry:geometry andByteOrder:CFByteOrderBigEndian];
    NSData * data2 = [SFWGeometryTestUtils writeDataWithGeometry:geometry andByteOrder:CFByteOrderLittleEndian];
    
    [SFWTestUtils assertFalse:[SFWGeometryTestUtils equalDataWithExpected:data1 andActual:data2]];
    
    // Test that the bytes are read using their written byte order, not
    // the specified
    SFGeometry * geometry1opposite = [SFWGeometryTestUtils readGeometryWithData:data1 andByteOrder:CFByteOrderLittleEndian];
    SFGeometry * geometry2opposite = [SFWGeometryTestUtils readGeometryWithData:data2 andByteOrder:CFByteOrderBigEndian];
    [SFWGeometryTestUtils compareDataWithExpected:[SFWGeometryTestUtils writeDataWithGeometry:compareGeometry]
                                        andActual:[SFWGeometryTestUtils writeDataWithGeometry:geometry1opposite]];
    [SFWGeometryTestUtils compareDataWithExpected:[SFWGeometryTestUtils writeDataWithGeometry:compareGeometry]
                                        andActual:[SFWGeometryTestUtils writeDataWithGeometry:geometry2opposite]];
    
    SFGeometry * geometry1 = [SFWGeometryTestUtils readGeometryWithData:data1 andByteOrder:CFByteOrderBigEndian];
    SFGeometry * geometry2 = [SFWGeometryTestUtils readGeometryWithData:data2 andByteOrder:CFByteOrderLittleEndian];
    
    [SFWGeometryTestUtils compareGeometriesWithExpected:compareGeometry andActual:geometry1];
    [SFWGeometryTestUtils compareGeometriesWithExpected:compareGeometry andActual:geometry2];
    [SFWGeometryTestUtils compareGeometriesWithExpected:geometry1 andActual:geometry2];

    SFGeometryEnvelope *envelope = [SFGeometryEnvelopeBuilder buildEnvelopeWithGeometry:compareGeometry];
    SFGeometryEnvelope *envelope1 = [SFGeometryEnvelopeBuilder buildEnvelopeWithGeometry:geometry1];
    SFGeometryEnvelope *envelope2 = [SFGeometryEnvelopeBuilder buildEnvelopeWithGeometry:geometry2];
    
    [SFWGeometryTestUtils compareEnvelopesWithExpected:envelope andActual:envelope1];
    [SFWGeometryTestUtils compareEnvelopesWithExpected:envelope1 andActual:envelope2];
}

+ (NSData *)hexStringToData: (NSString *) hex {
    const char *chars = [hex UTF8String];
    int i = 0;
    int len = (int)hex.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

@end
