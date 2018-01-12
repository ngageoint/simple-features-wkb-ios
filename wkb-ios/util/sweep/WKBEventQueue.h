//
//  WKBEventQueue.h
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBLineString.h"
#import "WKBEvent.h"

/**
 * Event queue for processing events
 */
@interface WKBEventQueue : NSObject

/**
 * Initialize
 *
 * @param ring
 *            polygon ring
 * @return event queue
 */
-(instancetype) initWithRing: (WKBLineString *) ring;

/**
 * Initialize
 *
 * @param rings
 *            polygon rings
 * @return event queue
 */
-(instancetype) initWithRings: (NSArray<WKBLineString *> *) rings;

/**
 * Get the events
 *
 * @return events
 */
-(NSArray<WKBEvent *> *) events;

@end
