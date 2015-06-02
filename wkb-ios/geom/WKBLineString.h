//
//  WKBLineString.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCurve.h"
#import "WKBPoint.h"

@interface WKBLineString : WKBCurve

@property (nonatomic, strong) NSMutableArray * points;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(void) addPoint: (WKBPoint *) point;

-(NSNumber *) numPoints;

@end
