//
//  WKBTriangle.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolygon.h"

@interface WKBTriangle : WKBPolygon

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
