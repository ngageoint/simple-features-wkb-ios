//
//  WKBGeometryTestUtils.h
//  wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometryEnvelope.h"
#import "WKBPoint.h"
#import "WKBLineString.h"
#import "WKBPolygon.h"
#import "WKBMultiPoint.h"
#import "WKBMultiLineString.h"
#import "WKBMultiPolygon.h"
#import "WKBGeometryCollection.h"
#import "WKBCircularString.h"
#import "WKBCompoundCurve.h"
#import "WKBCurvePolygon.h"
#import "WKBPolyhedralSurface.h"
#import "WKBTIN.h"
#import "WKBTriangle.h"


@interface WKBGeometryTestUtils : NSObject

+(void) compareEnvelopesWithExpected: (WKBGeometryEnvelope *) expected andActual: (WKBGeometryEnvelope *) actual;

+(void) compareGeometriesWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual;

+(void) compareBaseGeometryAttributesWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual;

+(void) comparePointWithExpected: (WKBPoint *) expected andActual: (WKBPoint *) actual;

+(void) compareLineStringWithExpected: (WKBLineString *) expected andActual: (WKBLineString *) actual;

+(void) comparePolygonWithExpected: (WKBPolygon *) expected andActual: (WKBPolygon *) actual;

+(void) compareMultiPointWithExpected: (WKBMultiPoint *) expected andActual: (WKBMultiPoint *) actual;

+(void) compareMultiLineStringWithExpected: (WKBMultiLineString *) expected andActual: (WKBMultiLineString *) actual;

+(void) compareMultiPolygonWithExpected: (WKBMultiPolygon *) expected andActual: (WKBMultiPolygon *) actual;

+(void) compareGeometryCollectionWithExpected: (WKBGeometryCollection *) expected andActual: (WKBGeometryCollection *) actual;

+(void) compareCircularStringWithExpected: (WKBCircularString *) expected andActual: (WKBCircularString *) actual;

+(void) compareCompoundCurveWithExpected: (WKBCompoundCurve *) expected andActual: (WKBCompoundCurve *) actual;

+(void) compareCurvePolygonWithExpected: (WKBCurvePolygon *) expected andActual: (WKBCurvePolygon *) actual;

+(void) comparePolyhedralSurfaceWithExpected: (WKBPolyhedralSurface *) expected andActual: (WKBPolyhedralSurface *) actual;

+(void) compareTINWithExpected: (WKBTIN *) expected andActual: (WKBTIN *) actual;

+(void) compareTriangleWithExpected: (WKBTriangle *) expected andActual: (WKBTriangle *) actual;

+(void) compareGeometryDataWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual;

+(void) compareGeometryDataWithExpected: (WKBGeometry *) expected andActual: (WKBGeometry *) actual andByteOrder: (CFByteOrder) byteOrder;

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(void) compareDataGeometriesWithExpected: (NSData *) expected andActual: (NSData *) actual andByteOrder: (CFByteOrder) byteOrder;

+(NSData *) writeDataWithGeometry: (WKBGeometry *) geometry;

+(NSData *) writeDataWithGeometry: (WKBGeometry *) geometry andByteOrder: (CFByteOrder) byteOrder;

+(WKBGeometry *) readGeometryWithData: (NSData *) data;

+(WKBGeometry *) readGeometryWithData: (NSData *) data andByteOrder: (CFByteOrder) byteOrder;

+(void) compareDataWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(BOOL) equalDataWithExpected: (NSData *) expected andActual: (NSData *) actual;

+(WKBPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring;

+(WKBPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
