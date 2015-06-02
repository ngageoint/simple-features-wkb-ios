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

@interface WKBGeometryReader : NSObject

+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader;

+(WKBGeometry *) readGeometryWithReader: (WKBByteReader *) reader andExpectedType: (Class) expectedType;

+(WKBPoint *) readPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBLineString *) readLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBPolygon *) readPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiPoint *) readMultiPointWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiLineString *) readMultiLineStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBMultiPolygon *) readMultiPolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBGeometryCollection *) readGeometryCollectionWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBCircularString *) readCircularStringWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBCompoundCurve *) readCompoundCurveWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBCurvePolygon *) readCurvePolygonWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBPolyhedralSurface *) readPolyhedralSurfaceWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBTIN *) readTINWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(WKBTriangle *) readTriangleWithReader: (WKBByteReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
