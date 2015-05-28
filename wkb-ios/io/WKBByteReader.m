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
        self.byteOrder = WKB_BIG_ENDIAN;
    }
    return self;
}

-(NSString *) readString: (int) num{
    //TODO
    return nil;
}

-(NSNumber *) readByte{
    //TODO
    return nil;
}

-(NSNumber *) readInt{
    //TODO
    return nil;
}

-(NSDecimalNumber *) readDouble{
    //TODO
    return nil;
}

@end
