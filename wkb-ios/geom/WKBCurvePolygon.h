//
//  WKBCurvePolygon.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBSurface.h"
#import "WKBCurve.h"

/**
 * A planar surface defined by an exterior ring and zero or more interior ring.
 * Each ring is defined by a Curve instance.
 */
@interface WKBCurvePolygon : WKBSurface

/**
 *  Array of rings
 */
@property (nonatomic, strong) NSMutableArray * rings;

/**
 *  Initialize
 *
 *  @return new curve polygon
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new curve polygon
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new curve polygon
 */
-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Add a ring
 *
 *  @param ring curve ring
 */
-(void) addRing: (WKBCurve *) ring;

/**
 *  Get the number of rings
 *
 *  @return ring count
 */
-(NSNumber *) numRings;

@end
