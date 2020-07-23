//
//  SFWTestUtils.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 11/10/15.
//  Copyright © 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFWTestUtils : NSObject

+(void)assertNil:(id) value;

+(void)assertNotNil:(id) value;

+(void)assertTrue: (BOOL) value;

+(void)assertFalse: (BOOL) value;

+(void)assertEqualWithValue:(NSObject *) value andValue2: (NSObject *) value2;

+(void)assertEqualBoolWithValue:(BOOL) value andValue2: (BOOL) value2;

+(void)assertEqualIntWithValue:(int) value andValue2: (int) value2;

+(void)assertEqualDoubleWithValue:(double) value andValue2: (double) value2;

+(void)assertEqualDoubleWithValue:(double) value andValue2: (double) value2 andDelta: (double) delta;

+(void)fail:(NSString *) message;

+(NSDecimalNumber *) roundDouble: (double) value;

+(NSDecimalNumber *) roundDouble: (double) value withScale: (int) scale;

+(int) randomIntLessThan: (int) max;

+(double) randomDouble;

+(double) randomDoubleLessThan: (double) max;

+(BOOL) coinFlip;

@end
