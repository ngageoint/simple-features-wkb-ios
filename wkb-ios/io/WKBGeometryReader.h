//
//  WKBGeometryReader.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBByteReader.h"
#import "WKBGeometry.h"
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

/**
 *  Well Known Binary Geometry Reader
 */
@interface WKBGeometryReader : NSObject

/**
 *  Read a geometry
 *
 *  @param reader reader
 *
 *  @return geometry
 */
+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader;

/**
 *  Read a geometry
 *
 *  @param reader       reader
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader andExpectedType: (Class) expectedType;

/**
 *  Read a point
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return point
 */
+(WKBPoint *) readPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
+(WKBLineString *) readLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
+(WKBPolygon *) readPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
+(WKBMultiPoint *) readMultiPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
+(WKBMultiLineString *) readMultiLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
+(WKBMultiPolygon *) readMultiPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
+(WKBGeometryCollection *) readGeometryCollectionWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
+(WKBCircularString *) readCircularStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
+(WKBCompoundCurve *) readCompoundCurveWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
+(WKBCurvePolygon *) readCurvePolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
+(WKBPolyhedralSurface *) readPolyhedralSurfaceWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
+(WKBTIN *) readTINWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param reader reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
+(WKBTriangle *) readTriangleWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
