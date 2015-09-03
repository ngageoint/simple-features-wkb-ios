//
//  WKBGeometryEnvelope.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Geometry envelope containing x and y range with optional z and m range
 */
@interface WKBGeometryEnvelope : NSObject

/**
 *  X coordinate range
 */
@property (nonatomic, strong) NSDecimalNumber * minX;
@property (nonatomic, strong) NSDecimalNumber * maxX;

/**
 *  Y coordinate range
 */
@property (nonatomic, strong) NSDecimalNumber * minY;
@property (nonatomic, strong) NSDecimalNumber * maxY;

/**
 * Has Z value and Z coordinate range
 */
@property (nonatomic) BOOL hasZ;
@property (nonatomic, strong) NSDecimalNumber * minZ;
@property (nonatomic, strong) NSDecimalNumber * maxZ;

/**
 *  Has M value and M coordinate range
 */
@property (nonatomic) BOOL hasM;
@property (nonatomic, strong) NSDecimalNumber * minM;
@property (nonatomic, strong) NSDecimalNumber * maxM;

/**
 *  Initialize with no z or m
 *
 *  @return new instance
 */
-(instancetype) init;

/**
 *  Initialize with the has z and m values
 *
 *  @param hasZ geometry has z
 *  @param hasM geometry has m
 *
 *  @return new geometry envelope
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
