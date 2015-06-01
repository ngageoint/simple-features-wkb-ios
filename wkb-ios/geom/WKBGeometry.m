//
//  WKBGeometry.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometry.h"

@implementation WKBGeometry

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.geometryType = geometryType;
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

-(int) getWkbCode{
    int code = [WKBGeometryTypes code:self.geometryType];
    if (self.hasZ) {
        code += 1000;
    }
    if (self.hasM) {
        code += 2000;
    }
    return code;
}

@end
