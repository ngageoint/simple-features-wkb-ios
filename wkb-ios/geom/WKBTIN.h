//
//  WKBTIN.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolyhedralSurface.h"

/**
 * A tetrahedron (4 triangular faces), corner at the origin and each unit
 * coordinate digit.
 */
@interface WKBTIN : WKBPolyhedralSurface

/**
 *  Initialize
 *
 *  @return new tin
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new tin
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
