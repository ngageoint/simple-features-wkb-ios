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

@interface WKBEvent : NSObject

-(instancetype) initWithEdge: (int) edge
                     andRing: (int) ring
                    andPoint: (WKBPoint *) point
                     andType: (enum WKBEventType) type;

-(int) edge;

-(int) ring;

-(WKBPoint *) point;

-(enum WKBEventType) type;

+(NSArray<WKBEvent *> *) sort: (NSArray<WKBEvent *> *) events;

@end
