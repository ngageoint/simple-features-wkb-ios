//
//  SFWGeometryTypeInfo.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 5/3/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFWGeometryTypeInfo.h"

@interface SFWGeometryTypeInfo()

/**
 * Geometry type code
 */
@property (nonatomic) int geometryTypeCode;

/**
 * Geometry type
 */
@property (nonatomic) enum SFGeometryType geometryType;

/**
 * Has Z values flag
 */
@property (nonatomic) BOOL hasZ;

/**
 * Has M values flag
 */
@property (nonatomic) BOOL hasM;

@end

@implementation SFWGeometryTypeInfo

-(instancetype) initWithCode: (int) geometryTypeCode andType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.geometryTypeCode = geometryTypeCode;
        self.geometryType = geometryType;
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

-(int) geometryTypeCode{
    return _geometryTypeCode;
}

-(enum SFGeometryType) geometryType{
    return _geometryType;
}

-(BOOL) hasZ{
    return _hasZ;
}

-(BOOL) hasM{
    return _hasM;
}

@end
