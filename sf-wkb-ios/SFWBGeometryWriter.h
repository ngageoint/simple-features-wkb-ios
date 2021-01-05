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
 * Initializer
 */
-(instancetype) init;

/**
 * Initializer
 *
 * @param byteOrder byte order
 */
-(instancetype) initWithByteOrder: (CFByteOrder) byteOrder;

/**
 * Initializer
 *
 * @param writer byte writer
 */
-(instancetype) initWithWriter: (SFByteWriter *) writer;

/**
 * Get the byte writer
 *
 * @return byte writer
 */
-(SFByteWriter *) byteWriter;

/**
 * Get the written byte data
 *
 * @return written byte data
 */
-(NSData *) data;

/**
 *  Close the byte writer
 */
-(void) close;

/**
 *  Write a geometry to the byte writer
 *
 *  @param geometry geometry
 */
-(void) write: (SFGeometry *) geometry;

/**
 *  Write a point
 *
 *  @param point  point
 */
-(void) writePoint: (SFPoint *) point;

/**
 *  Write a line string
 *
 *  @param lineString line string
 */
-(void) writeLineString: (SFLineString *) lineString;

/**
 *  Write a polygon
 *
 *  @param polygon polygon
 */
-(void) writePolygon: (SFPolygon *) polygon;

/**
 *  Write a multi point
 *
 *  @param multiPoint multi poing
 *  @param writer     byte writer
 */
-(void) writeMultiPoint: (SFMultiPoint *) multiPoint;

/**
 *  Write a multi line string
 *
 *  @param multiLineString multi line string
 */
-(void) writeMultiLineString: (SFMultiLineString *) multiLineString;

/**
 *  Write a multi polygon
 *
 *  @param multiPolygon multi polygon
 */
-(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon;

/**
 *  Write a geometry collection
 *
 *  @param geometryCollection geometry collection
 */
-(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection;

/**
 *  Write a circular string
 *
 *  @param circularString circular string
 */
-(void) writeCircularString: (SFCircularString *) circularString;

/**
 *  Write a compound curve
 *
 *  @param compoundCurve compound curve
 */
-(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve;

/**
 *  Write a curve polygon
 *
 *  @param curvePolygon curve polygon
 */
-(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon;

/**
 *  Write a polyhedral surface
 *
 *  @param polyhedralSurface polyhedral surface
 */
-(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface;

/**
 *  Write a TIN
 *
 *  @param tin    TIN
 */
-(void) writeTIN: (SFTIN *) tin;

/**
 *  Write a triangle
 *
 *  @param triangle triangle
 */
-(void) writeTriangle: (SFTriangle *) triangle;

/**
 *  Write a geometry to the byte writer
 *
 *  @param geometry geometry
 *  @param writer   byte writer
 */
+(void) writeGeometry: (SFGeometry *) geometry withWriter: (SFByteWriter *) writer;

/**
 *  Write a point
 *
 *  @param point  point
 *  @param writer byte writer
 */
+(void) writePoint: (SFPoint *) point withWriter: (SFByteWriter *) writer;

/**
 *  Write a line string
 *
 *  @param lineString line string
 *  @param writer     byte writer
 */
+(void) writeLineString: (SFLineString *) lineString withWriter: (SFByteWriter *) writer;

/**
 *  Write a polygon
 *
 *  @param polygon polygon
 *  @param writer  byte writer
 */
+(void) writePolygon: (SFPolygon *) polygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi point
 *
 *  @param multiPoint multi poing
 *  @param writer     byte writer
 */
+(void) writeMultiPoint: (SFMultiPoint *) multiPoint withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi line string
 *
 *  @param multiLineString multi line string
 *  @param writer          byte writer
 */
+(void) writeMultiLineString: (SFMultiLineString *) multiLineString withWriter: (SFByteWriter *) writer;

/**
 *  Write a multi polygon
 *
 *  @param multiPolygon multi polygon
 *  @param writer       byte writer
 */
+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a geometry collection
 *
 *  @param geometryCollection geometry collection
 *  @param writer             byte writer
 */
+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection withWriter: (SFByteWriter *) writer;

/**
 *  Write a circular string
 *
 *  @param circularString circular string
 *  @param writer         byte writer
 */
+(void) writeCircularString: (SFCircularString *) circularString withWriter: (SFByteWriter *) writer;

/**
 *  Write a compound curve
 *
 *  @param compoundCurve compound curve
 *  @param writer        byte writer
 */
+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve withWriter: (SFByteWriter *) writer;

/**
 *  Write a curve polygon
 *
 *  @param curvePolygon curve polygon
 *  @param writer       byte writer
 */
+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon withWriter: (SFByteWriter *) writer;

/**
 *  Write a polyhedral surface
 *
 *  @param polyhedralSurface polyhedral surface
 *  @param writer            byte writer
 */
+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface withWriter: (SFByteWriter *) writer;

/**
 *  Write a TIN
 *
 *  @param tin    TIN
 *  @param writer byte writer
 */
+(void) writeTIN: (SFTIN *) tin withWriter: (SFByteWriter *) writer;

/**
 *  Write a triangle
 *
 *  @param triangle triangle
 *  @param writer   byte writer
 */
+(void) writeTriangle: (SFTriangle *) triangle withWriter: (SFByteWriter *) writer;

@end
