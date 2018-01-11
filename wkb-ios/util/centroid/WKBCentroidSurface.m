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
#import "WKBCompoundCurve.h"

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
        case WKB_CURVEPOLYGON:
            [self addCurvePolygon:(WKBCurvePolygon *) geometry];
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

/**
 * Add polygons to the centroid total
 *
 * @param polygons
 *            polygons
 */
-(void) addPolygons: (NSArray *) polygons{
    for(WKBPolygon * polygon in polygons){
        [self addPolygon:polygon];
    }
}

/**
 * Add a polygon to the centroid total
 *
 * @param polygon
 *            polygon
 */
-(void) addPolygon: (WKBPolygon *) polygon{
    NSArray * rings = polygon.rings;
    [self addLineString:[rings objectAtIndex:0]];
    for(int i = 1; i < rings.count; i++){
        [self addHoleLineString: [rings objectAtIndex: i]];
    }
}

/**
 * Add a curve polygon to the centroid total
 *
 * @param curvePolygon
 *            curve polygon
 */
-(void) addCurvePolygon: (WKBCurvePolygon *) curvePolygon{
    
    NSArray * rings = curvePolygon.rings;
    
    WKBCurve * curve = [rings objectAtIndex:0];
    enum WKBGeometryType curveGeometryType = curve.geometryType;
    switch(curveGeometryType){
        case WKB_COMPOUNDCURVE:
            {
                WKBCompoundCurve * compoundCurve = (WKBCompoundCurve *) curve;
                for(WKBLineString * lineString in compoundCurve.lineStrings){
                    [self addLineString:lineString];
                }
                break;
            }
        case WKB_LINESTRING:
        case WKB_CIRCULARSTRING:
            [self addLineString:(WKBLineString *)curve];
            break;
        default:
            [NSException raise:@"Curve Type" format:@"Unexpected Curve Type: %d", curveGeometryType];
    }
    
    for(int i = 1; i < rings.count; i++){
        WKBCurve * curveHole = [rings objectAtIndex:i];
        enum WKBGeometryType curveHoleGeometryType = curveHole.geometryType;
        switch(curveHoleGeometryType){
            case WKB_COMPOUNDCURVE:
                {
                    WKBCompoundCurve * compoundCurveHole = (WKBCompoundCurve *) curveHole;
                    for(WKBLineString * lineStringHole in compoundCurveHole.lineStrings){
                        [self addHoleLineString:lineStringHole];
                    }
                    break;
                }
            case WKB_LINESTRING:
            case WKB_CIRCULARSTRING:
                [self addHoleLineString:(WKBLineString *)curveHole];
                break;
            default:
                [NSException raise:@"Curve Type" format:@"Unexpected Curve Type: %d", curveHoleGeometryType];
        }
    }
}

/**
 * Add a line string to the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addLineString: (WKBLineString *) lineString{
    [self addWithPositive:true andLineString:lineString];
}

/**
 * Add a line string hole to subtract from the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addHoleLineString: (WKBLineString *) lineString{
    [self addWithPositive:false andLineString:lineString];
}

/**
 * Add or subtract a line string to or from the centroid total
 *
 * @param positive
 *            true if an addition, false if a subtraction
 * @param lineString
 *            line string
 */
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

/**
 * Add or subtract a triangle of points to or from the centroid total
 *
 * @param positive
 *            true if an addition, false if a subtraction
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 */
-(void) addTriangleWithPositive: (BOOL) positive andPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 andPoint3: (WKBPoint *) point3{
    double sign = (positive) ? 1.0 : -1.0;
    WKBPoint * triangleCenter3 = [self centroid3WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    double area2 = [self area2WithPoint1:point1 andPoint2:point2 andPoint3:point3];
    [self.sum setX:[self.sum.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.x doubleValue]]]];
    [self.sum setY:[self.sum.y decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:sign * area2 * [triangleCenter3.y doubleValue]]]];
    self.area += sign * area2;
}

/**
 * Calculate three times the centroid of the point triangle
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 * @return 3 times centroid point
 */
-(WKBPoint *) centroid3WithPoint1: (WKBPoint *) point1 andPoint2: (WKBPoint *) point2 andPoint3: (WKBPoint *) point3{
    double x = [point1.x doubleValue] + [point2.x doubleValue] + [point3.x doubleValue];
    double y = [point1.y doubleValue] + [point2.y doubleValue] + [point3.y doubleValue];
    WKBPoint * point = [[WKBPoint alloc] initWithXValue:x andYValue:y];
    return point;
}

/**
 * Calculate twice the area of the point triangle
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @param point3
 *            point 3
 * @return 2 times triangle area
 */
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
