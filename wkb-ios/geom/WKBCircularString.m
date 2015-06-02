//
//  WKBCircularString.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCircularString.h"

@implementation WKBCircularString

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_CIRCULARSTRING andHasZ:hasZ andHasM:hasM];
    return self;
}

@end
