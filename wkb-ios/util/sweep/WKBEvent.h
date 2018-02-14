//
//  WKBEvent.h
//  wkb-ios
//
//  Created by Brian Osborn on 1/11/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBPoint.h"
#import "WKBEventTypes.h"

/**
 * Event element
 */
@interface WKBEvent : NSObject

/**
 * Initialize
 *
 * @param edge
 *            edge number
 * @param ring
 *            ring number
 * @param point
 *            point
 * @param type
 *            event type
 * @return event
 */
-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                    andPoint: (WKBPoint *) point
                     andType: (enum WKBEventType) type;

/**
 * Get the edge
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
 * Get the polygon point
 *
 * @return polygon point
 */
-(WKBPoint *) point;

/**
 * Get the event type
 *
 * @return event type
 */
-(enum WKBEventType) type;

/**
 * Sort the events
 *
 * @return sorted events
 */
+(NSArray<WKBEvent *> *) sort: (NSArray<WKBEvent *> *) events;

@end
