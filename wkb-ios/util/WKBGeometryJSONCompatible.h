//
//  WKBGeometryJSONCompatible.h
//  wkb-ios
//
//  Created by Brian Osborn on 3/16/16.
//  Copyright © 2016 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometry.h"

/**
 *  JSON compatible object representation of a Geometry
 */
@interface WKBGeometryJSONCompatible : NSObject

/**
 *  Get a Geometry object that is JSON compatible
 *
 *  @param geometry geometry
 *
 *  @return geometry JSON object
 */
+(NSObject *) getJSONCompatibleGeometry: (WKBGeometry *) geometry;

@end
