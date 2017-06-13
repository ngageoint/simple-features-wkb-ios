//
//  WKBTriangle.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolygon.h"

/**
 * Triangle
 */
@interface WKBTriangle : WKBPolygon

/**
 *  Initialize
 *
 *  @return new triangle
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new triangle
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
