//
//  WKBEvent.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/11/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBEvent.h"
#import "WKBSweepLine.h"

@interface WKBEvent()

/**
 * Edge number
 */
@property (nonatomic) int edge;

/**
 * Polygon ring number
 */
@property (nonatomic) int ring;

/**
 * Polygon point
 */
@property (nonatomic, strong) WKBPoint *point;

/**
 * Event type, left or right point
 */
@property (nonatomic) enum WKBEventType type;

@end

@implementation WKBEvent

-(instancetype) initWithEdge: (int) edge
                      andRing: (int) ring
                     andPoint: (WKBPoint *) point
                      andType: (enum WKBEventType) type{
    self = [super init];
    if(self != nil){
        self.edge = edge;
        self.ring = ring;
        self.point = point;
        self.type = type;
    }
    return self;
}

-(int) edge{
    return _edge;
}

-(int) ring{
    return _ring;
}

-(WKBPoint *) point{
    return _point;
}

-(enum WKBEventType) type{
    return _type;
}

- (NSComparisonResult) compare: (WKBEvent *) event{
    return [WKBSweepLine xyOrderWithPoint:self.point andPoint:event.point];
}

+(NSArray<WKBEvent *> *) sort: (NSArray<WKBEvent *> *) events{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sorted = [events sortedArrayUsingDescriptors:@[sort]];
    return sorted;
}

@end
