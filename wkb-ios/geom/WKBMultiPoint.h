//
//  WKBMultiPoint.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryCollection.h"
#import "WKBPoint.h"

@interface WKBMultiPoint : WKBGeometryCollection

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(NSMutableArray *) getPoints;

-(void) setPoints: (NSMutableArray *) points;

-(void) addPoint: (WKBPoint *) point;

-(NSNumber *) numPoints;

@end
