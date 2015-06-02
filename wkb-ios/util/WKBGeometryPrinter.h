//
//  WKBGeometryPrinter.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometry.h"

@interface WKBGeometryPrinter : NSObject

+(NSString *) getGeometryString: (WKBGeometry *) geometry;

@end
