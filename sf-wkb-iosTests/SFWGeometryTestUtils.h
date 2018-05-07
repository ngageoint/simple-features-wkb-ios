//
//  SFWGeometryTestUtils.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFGeometryEnvelope.h"
#import "SFPoint.h"
#import "SFLineString.h"
#import "SFPolygon.h"
#import "SFMultiPoint.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFGeometryCollection.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFCurvePolygon.h"
#import "SFPolyhedralSurface.h"
#import "SFTIN.h"
#import "SFTriangle.h"


@interface SFWGeometryTestUtils : NSObject

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual;

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual andDelta: (double) delta;

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andDelta: (double) delta;

+(void) compareBaseGeometryAttributesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual;

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual andDelta: (double) delta;

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual;

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual andDelta: (double) delta;

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual;

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual andDelta: (double) delta;

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual;

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual andDelta: (double) delta;

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual;

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual andDelta: (double) delta;

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual;

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual andDelta: (double) delta;

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual;

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual andDelta: (double) delta;

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual;

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual andDelta: (double) delta;

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual;

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual andDelta: (double) delta;

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual;

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual andDelta: (double) delta;

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual;

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual andDelta: (double) delta;

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual;

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual andDelta: (double) delta;

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual;

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual andDelta: (double) delta;

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) compareGeometryDataWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andByteOrder: (CFByteOrder) byteOrder;

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual andByteOrder: (CFByteOrder) byteOrder;

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry;

+(NSData *) writeDataWithGeometry: (SFGeometry *) geometry andByteOrder: (CFByteOrder) byteOrder;

+(SFGeometry *) readGeometryWithData: (NSData *) data;

+(SFGeometry *) readGeometryWithData: (NSData *) data andByteOrder: (CFByteOrder) byteOrder;

+(void) compareDataWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(BOOL) equalDataWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(void) compareDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta;

+(void) compareDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder;

+(int) countNonEqualDataWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(int) countNonEqualBytesWithExpected: (const char *) expected andActual: (const char *) actual andLength: (NSUInteger) length;

+(int) countNonEqualDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta;

+(int) countNonEqualDataDoubleComparisonsWithExpected: (NSData *) expected andActual: (NSData *) actual andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder;

+(int) countNonEqualBytesDoubleComparisonsWithExpected: (const char *) expected andActual: (const char *) actual andLength: (NSUInteger) length andDelta: (double) delta andByteOrder: (CFByteOrder) byteOrder;

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring;

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring;

+(SFCurvePolygon *) createCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFGeometryCollection *) createMultiCurve;

+(SFGeometryCollection *) createMultiSurface;

@end
