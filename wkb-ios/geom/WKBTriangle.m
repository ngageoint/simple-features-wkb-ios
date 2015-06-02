//
//  WKBTriangle.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBTriangle.h"

@implementation WKBTriangle

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_TRIANGLE andHasZ:hasZ andHasM:hasM];
    return self;
}

@end
