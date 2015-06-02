//
//  WKBCurvePolygon.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBSurface.h"
#import "WKBCurve.h"

@interface WKBCurvePolygon : WKBSurface

@property (nonatomic, strong) NSMutableArray * rings;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(void) addRing: (WKBCurve *) ring;

-(NSUInteger) numRings;

@end
