//
//  WKBPoint.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometry.h"

@interface WKBPoint : WKBGeometry

@property (nonatomic, strong) NSDecimalNumber * x;
@property (nonatomic, strong) NSDecimalNumber * y;
@property (nonatomic, strong) NSDecimalNumber * z;
@property (nonatomic, strong) NSDecimalNumber * m;

-(instancetype) initWithX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andX: (NSDecimalNumber *) x andY: (NSDecimalNumber *) y;

@end
