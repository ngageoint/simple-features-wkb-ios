//
//  WKBByteReader.m
//  wkb-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBByteReader.h"

@implementation WKBByteReader

-(instancetype) initWithData: (NSData *) bytes{
    self = [super init];
    if(self != nil){
        self.bytes = bytes;
        self.nextByte = 0;
        self.byteOrder = CFByteOrderBigEndian;
    }
    return self;
}

-(NSString *) readString: (int) num{
    char *buffer = (char *)malloc(sizeof(char) * (num +1));
    [self.bytes getBytes:buffer range:NSMakeRange(self.nextByte, num)];
    buffer[num] = '\0';
    NSString * value = [NSString stringWithUTF8String:buffer];
    self.nextByte += num;
    return value;
}

-(NSNumber *) readByte{
    char *buffer = (char *)malloc(sizeof(char));
    [self.bytes getBytes:buffer range:NSMakeRange(self.nextByte, 1)];
    int value = *(int*)buffer;
    self.nextByte++;
    free(buffer);
    return [NSNumber numberWithInt:value];
}

-(NSNumber *) readInt{
    char *buffer = (char *)malloc(sizeof(char) * 4);
    [self.bytes getBytes:buffer range:NSMakeRange(self.nextByte, 4)];
    
    uint32_t result = *(uint32_t*)buffer;
    
    if(self.byteOrder == CFByteOrderBigEndian){
        result = CFSwapInt32BigToHost(result);
    }else{
        result = CFSwapInt32LittleToHost(result);
    }
    
    self.nextByte += 4;
    free(buffer);
    
    return [NSNumber numberWithInt:result];
}

-(NSDecimalNumber *) readDouble{
    char *buffer = (char *)malloc(sizeof(char) * 8);
    [self.bytes getBytes:buffer range:NSMakeRange(self.nextByte, 8)];
    
    union DoubleSwap {
        double v;
        uint64_t sv;
    } result;
    result.sv = *(uint64_t*)buffer;
    
    if(self.byteOrder == CFByteOrderBigEndian){
        result.sv = CFSwapInt64BigToHost(result.sv);
    }else{
        result.sv = CFSwapInt64LittleToHost(result.sv);
    }
    
    self.nextByte += 8;
    free(buffer);
    
    return [[NSDecimalNumber alloc] initWithDouble:result.v];
}

@end
