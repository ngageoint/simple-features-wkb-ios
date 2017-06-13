//
//  WKBTriangle.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBTriangle.h"
#import "WKBLineString.h"

@implementation WKBTriangle

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_TRIANGLE andHasZ:hasZ andHasM:hasM];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBTriangle *triangle = [[WKBTriangle alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBLineString *ring in self.rings){
        [triangle addRing:[ring mutableCopy]];
    }
    return triangle;
}

@end
