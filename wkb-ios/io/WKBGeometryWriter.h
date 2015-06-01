//
//  WKBGeometryWriter.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBByteWriter.h"
#import "WKBGeometry.h"

@interface WKBGeometryWriter : NSObject

+(void) writeGeometry: (WKBGeometry *) geometry withWriter: (WKBByteWriter *) writer;

// TODO

@end
