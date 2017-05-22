//
//  WKBGeometry.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometryTypes.h"

/**
 *  The root of the geometry type hierarchy
 */
@interface WKBGeometry : NSObject <NSMutableCopying, NSCoding>

/**
 *  Geometry type
 */
@property (nonatomic) enum WKBGeometryType geometryType;

/**
 *  Has Z values
 */
@property (nonatomic) BOOL hasZ;

/**
 *  Has M values
 */
@property (nonatomic) BOOL hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new geometry
 */
-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the Well-Known Binary code
 *
 *  @return wkb code
 */
-(int) getWkbCode;

@end
