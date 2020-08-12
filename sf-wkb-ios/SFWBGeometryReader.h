//
//  SFWBGeometryReader.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFByteReader.h"
#import "SFGeometry.h"
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
#import "SFWBGeometryTypeInfo.h"
#import "SFGeometryFilter.h"

/**
 *  Well Known Binary Geometry Reader
 */
@interface SFWBGeometryReader : NSObject

/**
 *  Read a geometry from data
 *
 *  @param data data
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data;

/**
 *  Read a geometry from data
 *
 *  @param data data
 *  @param filter geometry filter
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry from data
 *
 *  @param data data
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andExpectedType: (Class) expectedType;

/**
 *  Read a geometry from data
 *
 *  @param data data
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 *  Read a geometry
 *
 *  @param reader reader
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader;

/**
 *  Read a geometry
 *
 *  @param reader reader
 *  @param filter geometry filter
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry
 *
 *  @param reader       reader
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andExpectedType: (Class) expectedType;

/**
 *  Read a geometry
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 *  Read a geometry
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param containingType containing geometry type
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (enum SFGeometryType) containingType andExpectedType: (Class) expectedType;

/**
 * Read the geometry type info
 *
 * @param reader
 *            byte reader
 * @return geometry type info
 */
+(SFWBGeometryTypeInfo *) readGeometryTypeWithReader: (SFByteReader *) reader;

/**
 *  Read a point
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return point
 */
+(SFPoint *) readPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
+(SFLineString *) readLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
+(SFPolygon *) readPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
+(SFMultiPoint *) readMultiPointWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
+(SFMultiLineString *) readMultiLineStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
+(SFMultiPolygon *) readMultiPolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
+(SFCircularString *) readCircularStringWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
+(SFCompoundCurve *) readCompoundCurveWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
+(SFCurvePolygon *) readCurvePolygonWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
+(SFTIN *) readTINWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
+(SFTIN *) readTINWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param reader reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
+(SFTriangle *) readTriangleWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
