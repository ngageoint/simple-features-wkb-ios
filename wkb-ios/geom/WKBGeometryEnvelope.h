//
//  WKBGeometryEnvelope.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBGeometryEnvelope : NSObject

@property (nonatomic, strong) NSDecimalNumber * minX;
@property (nonatomic, strong) NSDecimalNumber * maxX;
@property (nonatomic, strong) NSDecimalNumber * minY;
@property (nonatomic, strong) NSDecimalNumber * maxY;
@property (nonatomic) BOOL hasZ;
@property (nonatomic, strong) NSDecimalNumber * minZ;
@property (nonatomic, strong) NSDecimalNumber * maxZ;
@property (nonatomic) BOOL hasM;
@property (nonatomic, strong) NSDecimalNumber * minM;
@property (nonatomic, strong) NSDecimalNumber * maxM;

-(instancetype) init;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
