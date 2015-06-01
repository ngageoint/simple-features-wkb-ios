//
//  WKBGeometry.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometryTypes.h"

@interface WKBGeometry : NSObject

@property (nonatomic) enum WKBGeometryType geometryType;
@property (nonatomic) BOOL hasZ;
@property (nonatomic) BOOL hasM;

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(int) getWkbCode;

@end
