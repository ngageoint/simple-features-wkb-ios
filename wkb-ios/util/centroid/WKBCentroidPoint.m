//
//  WKBCentroidPoint.m
//  wkb-ios
//
//  Created by Brian Osborn on 4/14/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "WKBCentroidPoint.h"
#import "WKBMultiPoint.h"

@interface WKBCentroidPoint()

/**
 * Point count
 */
@property (nonatomic) int count;

/**
 * Sum of point locations
 */
@property (nonatomic, strong) WKBPoint * sum;

@end

@implementation WKBCentroidPoint

-(instancetype) init{
    return [self initWithGeometry:nil];
}

-(instancetype) initWithGeometry: (WKBGeometry *) geometry{
    self = [super init];
    if(self != nil){
        self.count = 0;
        self.sum = [[WKBPoint alloc] init];
        [self addGeometry:geometry];
    }
    return self;
}

-(void) addGeometry: (WKBGeometry *) geometry{
    enum WKBGeometryType geometryType = geometry.geometryType;
    switch (geometryType) {
        case WKB_POINT:
            [self addPoint:(WKBPoint *)geometry];
            break;
        case WKB_MULTIPOINT:
            {
                WKBMultiPoint * multiPoint = (WKBMultiPoint *) geometry;
                for(WKBPoint * point in [multiPoint getPoints]){
                    [self addPoint:point];
                }
            }
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
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Unsupported Geometry Type: %d", geometryType];
    }
}

/**
 * Add a point to the centroid total
 *
 * @param point
 *            point
 */
-(void) addPoint: (WKBPoint *) point{
    self.count++;
    [self.sum setX:[self.sum.x decimalNumberByAdding:point.x]];
    [self.sum setY:[self.sum.y decimalNumberByAdding:point.y]];
}

-(WKBPoint *) centroid{
    WKBPoint * centroid = [[WKBPoint alloc] initWithXValue:([self.sum.x doubleValue] / self.count) andYValue:([self.sum.y doubleValue] / self.count)];
    return centroid;
}

@end
