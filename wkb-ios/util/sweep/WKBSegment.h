//
//  WKBSegment.h
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBPoint.h"

/**
 * Line segment of an edge between two points
 */
@interface WKBSegment : NSObject

/**
 * Segment above
 */
@property (nonatomic, strong) WKBSegment *above;

/**
 * Segment below
 */
@property (nonatomic, strong) WKBSegment *below;

/**
 * Initialize
 *
 * @param edge
 *            edge number
 * @param ring
 *            ring number
 * @param leftPoint
 *            left point
 * @param rightPoint
 *            right point
 * @return segment
 */
-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                    andLeftPoint: (WKBPoint *) leftPoint
                     andRightPoint: (WKBPoint *) rightPoint;

/**
 * Get the edge number
 *
 * @return edge number
 */
-(int) edge;

/**
 * Get the polygon ring number
 *
 * @return polygon ring number
 */
-(int) ring;

/**
 * Get the left point
 *
 * @return left point
 */
-(WKBPoint *) leftPoint;

/**
 * Get the right point
 *
 * @return right point
 */
-(WKBPoint *) rightPoint;

@end
