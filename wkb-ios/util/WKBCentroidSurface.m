//
//  WKBCentroidSurface.m
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "WKBCentroidSurface.h"
#import "WKBLineString.h"
#import "WKBPolygon.h"
#import "WKBMultiPolygon.h"
#import "WKBPolyhedralSurface.h"
#import "WKBGeometryUtils.h"

@interface WKBCentroidSurface()

/**
 * Base point for triangles
 */
@property (nonatomic, strong) WKBPoint * base;

/**
 * Area sum
 */
@property (nonatomic) double area;

/**
 * Sum of surface point locations
 */
@property (nonatomic, strong) WKBPoint * sum;

@end

@implementation WKBCentroidSurface

-(instancetype) init{
    return [self initWithGeometry:nil];
}

-(instancetype) initWithGeometry: (WKBGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.area = 0;
        self.sum = [[WKBPoint alloc] init];
        [self addGeometry:geometry];
    }
    return self;
}

-(void) addGeometry: (WKBGeometry *) geometry{
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POLYGON:
        case WKB_TRIANGLE:
            [self addPolygon:(WKBPolygon *) geometry];
            break;
        case WKB_MULTIPOLYGON:
            [self addPolygons:[((WKBMultiPolygon *)geometry) getPolygons]];
            break;
        case WKB_POLYHEDRALSURFACE:
        case WKB_TIN:
            [self addPolygons:((WKBPolyhedralSurface *)geometry).polygons];
            break;
        case WKB_GEOMETRYCOLLECTION:
            {
                WKBGeometryCollection * geomCollection = (WKBGeometryCollection *) geometry;
                NSArray * geometries = geomCollection.geometries;
                for (WKBGeometry * subGeometry in geometries) {
                    [self addGeometry:subGeometry];
                }
            
            }
            break;
        case WKB_POINT:
        case WKB_MULTIPOINT:
        case WKB_LINESTRING:
        case WKB_CIRCULARSTRING:
        case WKB_MULTILINESTRING:
        case WKB_COMPOUNDCURVE:
            // Doesn't contribute to surface dimension
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
}

-(void) addPolygons: (NSArray *) polygons{
    for(WKBPolygon * polygon in polygons){
        [self addPolygon:polygon];
    }
}

-(void) addPolygon: (WKBPolygon *) polygon{
    NSArray * rings = polygon.rings;
    [self addWithLineString:[rings objectAtIndex:0]];
    for(int i = 1; i < rings.count; i++){
        [self addHoleWithLineString: [rings objectAtIndex: i]];
    }
}

-(void) addWithLineString: (WKBLineString *) lineString{
    [self addWithPositive:true andLineString:lineString];
}

-(void) addHoleWithLineString: (WKBLineString *) lineString{
    [self addWithPositive:false andLineString:lineString];
}

-(void) addWithPositive: (BOOL) positive andLineString: (WKBLineString *) lineString{
    NSArray * points = lineString.points;
    WKBPoint * firstPoint = [points objectAtIndex:0];
    if(self.base == nil){
        self.base = firstPoint;
    }
    for(int i = 0; i < points.count - 1; i++){
        WKBPoint * point = [points objectAtIndex:i];
        WKBPoint * nextPoint = [points objectAtIndex:i + 1];
        [self addTriangleWithPositive:positive andPoint1:self.base andPoint2:point andPoint3:nextPoint];
    }
    WKBPoint * lastPoint = [points objectAtIndex:points.count - 1];
    if([firstPoint.x doubleValue] != [lastPoint.x doubleValue] || [firstPoint.y doubleValue] != [lastPoint.y doubleValue]){
        [self addTriangleWithPositive:positive andPoint1:self.base andPoint2:lastPoint andPoint3:firstPoint];
    }
}

-(void) addTriangleWithPositive: (BOOL) positive andPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 andPoint3: (WKBPoint *) point3{
    double sign = (positive) ? 1.0 : -1.0;
    WKBPoint * triangleCenter3 = [self centroid3WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    double area2 = [self area2WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    [self.sum setX:[self.sum.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.x doubleValue]]]];
    [self.sum setY:[self.sum.y decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.y doubleValue]]]];
    self.area += sign * area2;
}

-(WKBPoint *) centroid3WithPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 andPoint3: (WKBPoint *) point3{
    double x = [point1.x doubleValue] + [point2.x doubleValue] + [point3.x doubleValue];
    double y = [point1.y doubleValue] + [point2.y doubleValue] + [point3.y doubleValue];
    WKBPoint * point = [[WKBPoint alloc] initWithXValue:x andYValue:y];
    return point;
}

-(double) area2WithPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 andPoint3: (WKBPoint *) point3{
    return ([point2.x doubleValue] - [point1.x doubleValue])
				* ([point3.y doubleValue] - [point1.y doubleValue])
				- ([point3.x doubleValue] - [point1.x doubleValue])
				* ([point2.y doubleValue] - [point1.y doubleValue]);
}

-(WKBPoint *) centroid{
    WKBPoint * centroid = [[WKBPoint alloc] initWithXValue:([self.sum.x doubleValue] / 3 / self.area) andYValue:([self.sum.y doubleValue] / 3 / self.area)];
    return centroid;
}

@end
