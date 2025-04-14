//
//  SFWBGeometryReader.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SimpleFeatures/SimpleFeatures.h>
#import <SimpleFeaturesWKB/SFWBGeometryTypeInfo.h>

/**
 *  Well Known Binary Geometry Reader
 */
@interface SFWBGeometryReader : NSObject

/**
 *  Read a geometry from data
 *
 *  @param data geometry data
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data;

/**
 *  Read a geometry from data
 *
 *  @param data geometry data
 *  @param filter geometry filter
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry from data
 *
 *  @param data geometry data
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andExpectedType: (Class) expectedType;

/**
 *  Read a geometry from data
 *
 *  @param data geometry data
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithData: (NSData *) data andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 * Initializer
 *
 * @param data geometry data
 */
-(instancetype) initWithData: (NSData *) data;

/**
 * Initializer
 *
 * @param reader byte reader
 */
-(instancetype) initWithReader: (SFByteReader *) reader;

/**
 * Get the byte reader
 *
 * @return byte reader
 */
-(SFByteReader *) byteReader;

/**
 *  Read a geometry from the byte reader
 *
 *  @return geometry
 */
-(SFGeometry *) read;

/**
 *  Read a geometry from the byte reader
 *
 *  @param filter geometry filter
 *
 *  @return geometry
 */
-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry from the byte reader
 *
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
-(SFGeometry *) readWithExpectedType: (Class) expectedType;

/**
 *  Read a geometry from the byte reader
 *
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 *  Read a geometry from the byte reader
 *
 *  @param filter geometry filter
 *  @param containingType containing geometry type
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter inType: (SFGeometryType) containingType andExpectedType: (Class) expectedType;

/**
 * Read the geometry type info
 *
 * @return geometry type info
 */
-(SFWBGeometryTypeInfo *) readGeometryType;

/**
 *  Read a point
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return point
 */
-(SFPoint *) readPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
-(SFLineString *) readLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
-(SFLineString *) readLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
-(SFPolygon *) readPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
-(SFPolygon *) readPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
-(SFMultiPoint *) readMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
-(SFMultiPoint *) readMultiPointWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
-(SFMultiLineString *) readMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
-(SFMultiLineString *) readMultiLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
-(SFMultiPolygon *) readMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
-(SFMultiPolygon *) readMultiPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
-(SFGeometryCollection *) readGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
-(SFGeometryCollection *) readGeometryCollectionWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
-(SFCircularString *) readCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
-(SFCircularString *) readCircularStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
-(SFCompoundCurve *) readCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
-(SFCompoundCurve *) readCompoundCurveWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
-(SFCurvePolygon *) readCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
-(SFCurvePolygon *) readCurvePolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
-(SFPolyhedralSurface *) readPolyhedralSurfaceWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
-(SFPolyhedralSurface *) readPolyhedralSurfaceWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
-(SFTIN *) readTINWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
-(SFTIN *) readTINWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
-(SFTriangle *) readTriangleWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
-(SFTriangle *) readTriangleWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

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
+(SFGeometry *) readGeometryWithReader: (SFByteReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (SFGeometryType) containingType andExpectedType: (Class) expectedType;

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
