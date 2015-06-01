//
//  WKBGeometryEnvelope.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometryEnvelope.h"

@implementation WKBGeometryEnvelope

-(instancetype) init{
    return [self initWithHasZ:false andHasM:false];
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

@end
