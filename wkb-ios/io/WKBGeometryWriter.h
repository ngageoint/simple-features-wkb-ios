//
//  WKBGeometryWriter.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBByteWriter.h"
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
 *  Well Known Binary Geometry Writer
 */
@interface WKBGeometryWriter : NSObject

/**
 *  Write a geometry
 *
 *  @param geometry geometry
 *  @param writer   writer
 */
+(void) writeGeometry: (WKBGeometry *) geometry withWriter: (WKBByteWriter *) writer;

/**
 *  Write a point
 *
 *  @param point  point
 *  @param writer writer
 */
+(void) writePoint: (WKBPoint *) point withWriter: (WKBByteWriter *) writer;

/**
 *  Write a line string
 *
 *  @param lineString line string
 *  @param writer     writer
 */
+(void) writeLineString: (WKBLineString *) lineString withWriter: (WKBByteWriter *) writer;

/**
 *  Write a polygon
 *
 *  @param polygon polygon
 *  @param writer  writer
 */
+(void) writePolygon: (WKBPolygon *) polygon withWriter: (WKBByteWriter *) writer;

/**
 *  Write a multi point
 *
 *  @param multiPoint multi poing
 *  @param writer     writer
 */
+(void) writeMultiPoint: (WKBMultiPoint *) multiPoint withWriter: (WKBByteWriter *) writer;

/**
 *  Write a multi line string
 *
 *  @param multiLineString multi line string
 *  @param writer          writer
 */
+(void) writeMultiLineString: (WKBMultiLineString *) multiLineString withWriter: (WKBByteWriter *) writer;

/**
 *  Write a multi polygon
 *
 *  @param multiPolygon multi polygon
 *  @param writer       writer
 */
+(void) writeMultiPolygon: (WKBMultiPolygon *) multiPolygon withWriter: (WKBByteWriter *) writer;

/**
 *  Write a geometry collection
 *
 *  @param geometryCollection geometry collection
 *  @param writer             writer
 */
+(void) writeGeometryCollection: (WKBGeometryCollection *) geometryCollection withWriter: (WKBByteWriter *) writer;

/**
 *  Write a circular string
 *
 *  @param circularString circular string
 *  @param writer         writer
 */
+(void) writeCircularString: (WKBCircularString *) circularString withWriter: (WKBByteWriter *) writer;

/**
 *  Write a compound curve
 *
 *  @param compoundCurve compound curve
 *  @param writer        writer
 */
+(void) writeCompoundCurve: (WKBCompoundCurve *) compoundCurve withWriter: (WKBByteWriter *) writer;

/**
 *  Write a curve polygon
 *
 *  @param curvePolygon curve polygon
 *  @param writer       writer
 */
+(void) writeCurvePolygon: (WKBCurvePolygon *) curvePolygon withWriter: (WKBByteWriter *) writer;

/**
 *  Write a polyhedral surface
 *
 *  @param polyhedralSurface polyhedral surface
 *  @param writer            writer
 */
+(void) writePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withWriter: (WKBByteWriter *) writer;

/**
 *  Write a TIN
 *
 *  @param tin    TIN
 *  @param writer writer
 */
+(void) writeTIN: (WKBTIN *) tin withWriter: (WKBByteWriter *) writer;

/**
 *  Write a triangle
 *
 *  @param triangle triangle
 *  @param writer   writer
 */
+(void) writeTriangle: (WKBTriangle *) triangle withWriter: (WKBByteWriter *) writer;

@end
