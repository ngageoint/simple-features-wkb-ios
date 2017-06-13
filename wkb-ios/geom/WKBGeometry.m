//
//  WKBGeometry.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBGeometry.h"
#import "WKBByteWriter.h"
#import "WKBGeometryWriter.h"
#import "WKBByteReader.h"
#import "WKBGeometryReader.h"

@implementation WKBGeometry

-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.geometryType = geometryType;
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

-(int) getWkbCode{
    int code = [WKBGeometryTypes code:self.geometryType];
    if (self.hasZ) {
        code += 1000;
    }
    if (self.hasM) {
        code += 2000;
    }
    return code;
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    [NSException raise:@"Abstract" format:@"Can not copy abstract geometry"];
    return nil;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    NSData *data = nil;
    WKBByteWriter *writer = [[WKBByteWriter alloc] init];
    @try {
        writer.byteOrder = CFByteOrderBigEndian;
        [WKBGeometryWriter writeGeometry:self withWriter:writer];
        data = [writer getData];
    } @catch (NSException *e) {
        [NSException raise:@"Encode failure" format:@"Failed to encode geometry: %d, Exception Name: %@, Reason: %@", self.geometryType, e.name, e.reason];
    } @finally {
        [writer close];
    }
    [encoder encodeDataObject:data];
}

- (id) initWithCoder:(NSCoder *)decoder {
    WKBByteReader *reader = [[WKBByteReader alloc] initWithData: [decoder decodeDataObject]];
    reader.byteOrder = CFByteOrderBigEndian;
    WKBGeometry *geometry = [WKBGeometryReader readGeometryWithReader: reader];
    return geometry;
}

@end
