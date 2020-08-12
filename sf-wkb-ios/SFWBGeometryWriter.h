//
//  SFWBGeometryWriter.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFByteWriter.h"
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

/**
 *  Well Known Binary Geometry Writer
 */
@interface SFWBGeometryWriter : NSObject

/**
 *  Write a geometry to well-known bytes
 *
 *  @param geometry geometry
 *  @return well-known bytes
 */
+(NSData *) writeGeometry: (SFGeometry *) geometry;

/**
 *  Write a geometry to well-known bytes
 *
 *  @param geometry geometry
 *  @param byteOrder byte order
 *  @return well-known bytes
 */
+(NSData *) writeGeometry: (SFGeometry *) geometry inByteOrder: (CFByteOrder) byteOrder;

/**
 *  Write a geometry
 *
 *  @param geometry geometry
 *  @param writer   writer
 */
+(void) writeGeometry: (SFGeometry *) geometry withWriter: (SFByteWriter *) writer;

/**
 *  Write a point
 *
 *  @param point  point
 *  @param writer writer
 */
+(void) writePoint: (SFPoint *) point withWriter: (SFByteWriter *) writer;

/**
 *  Write a line string
 *
 *  @param lineString line string
 *  @param writer     writer
 */
+(void) writeLineString: (SFLineString *) lineString withWriter: (SFByteWriter *) writer;

/**
 *  Write a polygon
 *
 *  @param polygon polygon
 *  @param writer  writer
 */
+(void) writePolygon: (SFPolygon *) polygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi point
 *
 *  @param multiPoint multi poing
 *  @param writer     writer
 */
+(void) writeMultiPoint: (SFMultiPoint *) multiPoint withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi line string
 *
 *  @param multiLineString multi line string
 *  @param writer          writer
 */
+(void) writeMultiLineString: (SFMultiLineString *) multiLineString withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi polygon
 *
 *  @param multiPolygon multi polygon
 *  @param writer       writer
 */
+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a geometry collection
 *
 *  @param geometryCollection geometry collection
 *  @param writer             writer
 */
+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection withWriter: (SFByteWriter *) writer;

/**
 *  Write a circular string
 *
 *  @param circularString circular string
 *  @param writer         writer
 */
+(void) writeCircularString: (SFCircularString *) circularString withWriter: (SFByteWriter *) writer;

/**
 *  Write a compound curve
 *
 *  @param compoundCurve compound curve
 *  @param writer        writer
 */
+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve withWriter: (SFByteWriter *) writer;

/**
 *  Write a curve polygon
 *
 *  @param curvePolygon curve polygon
 *  @param writer       writer
 */
+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a polyhedral surface
 *
 *  @param polyhedralSurface polyhedral surface
 *  @param writer            writer
 */
+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withWriter: (SFByteWriter *) writer;

/**
 *  Write a TIN
 *
 *  @param tin    TIN
 *  @param writer writer
 */
+(void) writeTIN: (SFTIN *) tin withWriter: (SFByteWriter *) writer;

/**
 *  Write a triangle
 *
 *  @param triangle triangle
 *  @param writer   writer
 */
+(void) writeTriangle: (SFTriangle *) triangle withWriter: (SFByteWriter *) writer;

@end
