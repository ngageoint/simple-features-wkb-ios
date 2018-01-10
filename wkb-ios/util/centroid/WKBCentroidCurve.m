//
//  WKBCentroidCurve.m
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "WKBCentroidCurve.h"
#import "WKBLineString.h"
#import "WKBGeometryUtils.h"
#import "WKBMultiLineString.h"
#import "WKBCompoundCurve.h"

@interface WKBCentroidCurve()

/**
 * Sum of curve point locations
 */
@property (nonatomic, strong) WKBPoint * sum;

/**
 * Total length of curves
 */
@property (nonatomic) double totalLength;

@end

@implementation WKBCentroidCurve

-(instancetype) init{
    return [self initWithGeometry:nil];
}

-(instancetype) initWithGeometry: (WKBGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.sum = [[WKBPoint alloc] init];
        self.totalLength = 0;
        [self addGeometry:geometry];
    }
    return self;
}

-(void) addGeometry: (WKBGeometry *) geometry{
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_LINESTRING:
        case WKB_CIRCULARSTRING:
            [self addLineString:(WKBLineString *)geometry];
            break;
        case WKB_MULTILINESTRING:
            [self addLineStrings:[((WKBMultiLineString *)geometry) getLineStrings]];
            break;
        case WKB_COMPOUNDCURVE:
            [self addLineStrings:((WKBCompoundCurve *)geometry).lineStrings];
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
            // Doesn't contribute to curve dimension
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
}

/**
 * Add line strings to the centroid total
 *
 * @param lineStrings
 *            line strings
 */
-(void) addLineStrings: (NSArray *) lineStrings{
    for(WKBLineString * lineString in lineStrings){
        [self addLineString:lineString];
    }
}

/**
 * Add a line string to the centroid total
 *
 * @param lineString
 *            line string
 */
-(void) addLineString: (WKBLineString *) lineString{
    [self addPoints:lineString.points];
}

/**
 * Add points to the centroid total
 *
 * @param points
 *            points
 */
-(void) addPoints: (NSArray *) points{
    for(int i = 0; i < points.count - 1; i++){
        WKBPoint * point = [points objectAtIndex:i];
        WKBPoint * nextPoint = [points objectAtIndex:i + 1];
        
        double length = [WKBGeometryUtils distanceBetweenPoint1:point andPoint2:nextPoint];
        self.totalLength += length;
        
        double midX = ([point.x doubleValue] + [nextPoint.x doubleValue]) / 2;
        [self.sum setX:[self.sum.x decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:length * midX]]];
        double midY = ([point.y doubleValue] + [nextPoint.y doubleValue]) / 2;
        [self.sum setY:[self.sum.y decimalNumberByAdding:[[NSDecimalNumber alloc] initWithDouble:length * midY]]];
    }
}

-(WKBPoint *) centroid{
    WKBPoint * centroid = [[WKBPoint alloc] initWithXValue:([self.sum.x doubleValue] / self.totalLength) andYValue:([self.sum.y doubleValue] / self.totalLength)];
    return centroid;
}

@end
