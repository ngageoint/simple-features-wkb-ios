//
//  WKBGeometryPrinter.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometry.h"

/**
 *  String representation of a Geometry
 */
@interface WKBGeometryPrinter : NSObject

/**
 *  Get Geometry information as a String
 *
 *  @param geometry geometry
 *
 *  @return geometry string
 */
+(NSString *) getGeometryString: (WKBGeometry *) geometry;

@end
