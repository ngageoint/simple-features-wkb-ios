//
//  WKBCompoundCurve.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCurve.h"
#import "WKBLineString.h"

@interface WKBCompoundCurve : WKBCurve

@property (nonatomic, strong) NSMutableArray * lineStrings;

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(void) addLineString: (WKBLineString *) lineString;

-(NSUInteger) numLineStrings;

@end
