//
//  WKBPoint.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPoint.h"

@implementation WKBPoint

-(instancetype) initWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    return [self initWithHasZ:false andHasM:false andX:x andY:y];
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y{
    self = [super initWithType:WKB_POINT andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.x = x;
        self.y = y;
    }
    return self;
}

@end
