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

@interface WKBGeometryWriter : NSObject

+(void) writeGeometry: (WKBGeometry *) geometry withWriter: (WKBByteWriter *) writer;

+(void) writePoint: (WKBPoint *) point withWriter: (WKBByteWriter *) writer;

+(void) writeLineString: (WKBLineString *) lineString withWriter: (WKBByteWriter *) writer;

+(void) writePolygon: (WKBPolygon *) polygon withWriter: (WKBByteWriter *) writer;

+(void) writeMultiPoint: (WKBMultiPoint *) multiPoint withWriter: (WKBByteWriter *) writer;

+(void) writeMultiLineString: (WKBMultiLineString *) multiLineString withWriter: (WKBByteWriter *) writer;

+(void) writeMultiPolygon: (WKBMultiPolygon *) multiPolygon withWriter: (WKBByteWriter *) writer;

+(void) writeGeometryCollection: (WKBGeometryCollection *) geometryCollection withWriter: (WKBByteWriter *) writer;

+(void) writeCircularString: (WKBCircularString *) circularString withWriter: (WKBByteWriter *) writer;

+(void) writeCompoundCurve: (WKBCompoundCurve *) compoundCurve withWriter: (WKBByteWriter *) writer;

+(void) writeCurvePolygon: (WKBCurvePolygon *) curvePolygon withWriter: (WKBByteWriter *) writer;

+(void) writePolyhedralSurface: (WKBPolyhedralSurface *) polyhedralSurface withWriter: (WKBByteWriter *) writer;

+(void) writeTIN: (WKBTIN *) tin withWriter: (WKBByteWriter *) writer;

+(void) writeTriangle: (WKBTriangle *) triangle withWriter: (WKBByteWriter *) writer;

@end
