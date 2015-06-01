//
//  WKBByteReader.h
//  wkb-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBByteReader : NSObject

@property (nonatomic) int nextByte;
@property (nonatomic, strong) NSData *bytes;
@property (nonatomic) CFByteOrder byteOrder;

-(instancetype) initWithData: (NSData *) bytes;

-(NSString *) readString: (int) num;

-(NSNumber *) readByte;

-(NSNumber *) readInt;

-(NSDecimalNumber *) readDouble;

@end
