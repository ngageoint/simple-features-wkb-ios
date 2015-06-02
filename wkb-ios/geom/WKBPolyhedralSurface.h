//
//  WKBPolyhedralSurface.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBSurface.h"
#import "WKBPolygon.h"

@interface WKBPolyhedralSurface : WKBSurface

@property (nonatomic, strong) NSMutableArray * polygons;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(void) addPolygon: (WKBPolygon *) polygon;

-(NSUInteger) numPolygons;

@end
