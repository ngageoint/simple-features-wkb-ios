//
//  WKBSweepLine.h
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBPoint.h"
#import "WKBSegment.h"
#import "WKBEvent.h"
#import "WKBLineString.h"

/**
 * Sweep Line algorithm
 */
@interface WKBSweepLine : NSObject

/**
 * Initialize
 *
 * @param rings
 *            polygon rings
 * @return sweep line
 */
-(instancetype) initWithRings: (NSArray<WKBLineString *> *) rings;

/**
 * Add the event to the sweep line
 *
 * @param event
 *            event
 * @return added segment
 */
-(WKBSegment *) addEvent: (WKBEvent *) event;

/**
 * Find the existing event segment
 *
 * @param event
 *            event
 * @return segment
 */
-(WKBSegment *) findEvent: (WKBEvent *) event;

/**
 * Determine if the two segments intersect
 *
 * @param segment1
 *            segment 1
 * @param segment2
 *            segment 2
 * @return true if intersection, false if not
 */
-(BOOL) intersectWithSegment: (WKBSegment *) segment1 andSegment: (WKBSegment *) segment2;

/**
 * Remove the segment from the sweep line
 *
 * @param segment
 *            segment
 */
-(void) removeSegment: (WKBSegment *) segment;

/**
 * XY order of two points
 *
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return NSOrderedDescending if p1 > p2, NSOrderedAscending if p1 < p2, NSOrderedSame if equal
 */
+(NSComparisonResult) xyOrderWithPoint: (WKBPoint *) point1 andPoint: (WKBPoint *) point2;

@end
