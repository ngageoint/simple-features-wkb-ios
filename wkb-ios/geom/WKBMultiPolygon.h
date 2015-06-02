//
//  WKBMultiPolygon.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiSurface.h"
#import "WKBPolygon.h"

@interface WKBMultiPolygon : WKBMultiSurface

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(NSMutableArray *) getPolygons;

-(void) setPolygons: (NSMutableArray *) polygons;

-(void) addPolygon: (WKBPolygon *) polygon;

-(NSNumber *) numPolygons;

@end
