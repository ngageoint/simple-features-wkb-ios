//
//  WKBMultiLineString.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiCurve.h"
#import "WKBLineString.h"

@interface WKBMultiLineString : WKBMultiCurve

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

-(NSMutableArray *) getLineStrings;

-(void) setLineStrings: (NSMutableArray *) lineStrings;

-(void) addLineString: (WKBLineString *) lineString;

-(NSNumber *) numLineStrings;

@end
