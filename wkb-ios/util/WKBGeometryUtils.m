//
//  WKBGeometryUtils.m
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "WKBGeometryUtils.h"
#import "WKBGeometryCollection.h"
#import "WKBCentroidPoint.h"
#import "WKBCentroidCurve.h"
#import "WKBCentroidSurface.h"

@implementation WKBGeometryUtils

+(int) dimensionOfGeometry: (WKBGeometry *) geometry{
    
    int dimension = -1;
    
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
        case WKB_MULTIPOINT:
            dimension = 0;
            break;
        case WKB_LINESTRING:
        case WKB_MULTILINESTRING:
        case WKB_CIRCULARSTRING:
        case WKB_COMPOUNDCURVE:
            dimension = 1;
            break;
        case WKB_POLYGON:
        case WKB_CURVEPOLYGON:
        case WKB_MULTIPOLYGON:
        case WKB_POLYHEDRALSURFACE:
        case WKB_TIN:
        case WKB_TRIANGLE:
            dimension = 2;
            break;
        case WKB_GEOMETRYCOLLECTION:
            {
                WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
                NSArray * geometries = geomCollection.geometries;
                for (WKBGeometry * subGeometry in geometries) {
                    dimension = MAX(dimension, [self dimensionOfGeometry:subGeometry]);
                }
            }
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
    
    return dimension;
}

+(double) distanceBetweenPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2{
    double diffX = [point1.x doubleValue] - [point2.x doubleValue];
    double diffY = [point1.y doubleValue] - [point2.y doubleValue];
    
    double distance = sqrt(diffX * diffX + diffY * diffY);
    
    return distance;
}

+(WKBPoint *) centroidOfGeometry: (WKBGeometry *) geometry{
    WKBPoint * centroid = nil;
    int dimension = [self dimensionOfGeometry:geometry];
    switch (dimension) {
        case 0:
            {
                WKBCentroidPoint * point = [[WKBCentroidPoint alloc] initWithGeometry: geometry];
                centroid = [point centroid];
            }
            break;
        case 1:
            {
                WKBCentroidCurve * curve = [[WKBCentroidCurve alloc] initWithGeometry: geometry];
                centroid = [curve centroid];
            }
            break;
        case 2:
            {
                WKBCentroidSurface * surface = [[WKBCentroidSurface alloc] initWithGeometry: geometry];
                centroid = [surface centroid];
            }
            break;
    }
    return centroid;
}

@end
