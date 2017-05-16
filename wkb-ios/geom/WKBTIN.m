//
//  WKBTIN.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBTIN.h"

@implementation WKBTIN

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_TIN andHasZ:hasZ andHasM:hasM];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBTIN *tin = [[WKBTIN alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBPolygon *polygon in self.polygons){
        [tin addPolygon:[polygon mutableCopy]];
    }
    return tin;
}

@end
