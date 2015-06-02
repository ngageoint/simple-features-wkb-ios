//
//  WKBGeometryEnvelopeBuilder.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometryEnvelope.h"
#import "WKBGeometry.h"

@interface WKBGeometryEnvelopeBuilder : NSObject

+(WKBGeometryEnvelope *) buildEnvelopeWithGeometry: (WKBGeometry *) geometry;

+(void) buildEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry;

@end
