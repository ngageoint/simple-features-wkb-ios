//
//  WKBCircularString.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCircularString.h"

@implementation WKBCircularString

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_CIRCULARSTRING andHasZ:hasZ andHasM:hasM];
    return self;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBCircularString *circularString = [[WKBCircularString alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBPoint *point in self.points){
        [circularString addPoint:[point mutableCopy]];
    }
    return circularString;
}

@end
