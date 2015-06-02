//
//  WKBByteWriter.h
//  wkb-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKBByteWriter : NSObject

@property (nonatomic, strong) NSOutputStream * os;
@property (nonatomic) CFByteOrder byteOrder;

-(instancetype) init;

-(void) close;

-(NSData *) getData;

-(int) size;

-(void) writeString: (NSString *) value;

-(void) writeByte: (NSNumber *) value;

-(void) writeInt: (NSNumber *) value;

-(void) writeDouble: (NSDecimalNumber *) value;

@end
