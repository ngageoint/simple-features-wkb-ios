//
//  WKBTIN.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBPolyhedralSurface.h"

@interface WKBTIN : WKBPolyhedralSurface

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
