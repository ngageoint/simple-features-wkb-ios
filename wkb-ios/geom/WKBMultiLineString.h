//
//  WKBMultiLineString.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiCurve.h"
#import "WKBLineString.h"

/**
 * A restricted form of MultiCurve where each Curve in the collection must be of
 * type LineString.
 */
@interface WKBMultiLineString : WKBMultiCurve

/**
 *  Initialize
 *
 *  @return new multi line string
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new multi line string
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Get the line strings
 *
 *  @return line strings
 */
-(NSMutableArray *) getLineStrings;

/**
 *  Set the line strings
 *
 *  @param lineStrings line strings
 */
-(void) setLineStrings: (NSMutableArray *) lineStrings;

/**
 *  Add a line string
 *
 *  @param lineString line string
 */
-(void) addLineString: (WKBLineString *) lineString;

/**
 *  Get the number of line strings
 *
 *  @return line string count
 */
-(NSNumber *) numLineStrings;

@end
