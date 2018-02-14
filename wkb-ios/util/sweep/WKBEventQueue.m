//
//  WKBEventQueue.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBEventQueue.h"
#import "WKBSweepLine.h"

@interface WKBEventQueue()

@property (nonatomic, strong) NSArray<WKBEvent *> *events;

@end

@implementation WKBEventQueue

-(instancetype) initWithRing: (WKBLineString *) ring{
    return [self initWithRings:[[NSArray alloc] initWithObjects:ring, nil]];
}

-(instancetype) initWithRings: (NSArray<WKBLineString *> *) rings{
    self = [super init];
    if(self != nil){
        NSMutableArray<WKBEvent *> *buildEvents = [[NSMutableArray alloc] init];
        for(int i = 0; i < rings.count; i++){
            WKBLineString *ring = [rings objectAtIndex:i];
            [self addRing:ring withIndex:i toEvents:buildEvents];
        }
        self.events = [WKBEvent sort:buildEvents];
    }
    return self;
}

-(void) addRing: (WKBLineString *) ring withIndex: (int) ringIndex toEvents: (NSMutableArray<WKBEvent *> *) events{
    
    NSArray *points = ring.points;
    
    for (int i = 0; i < points.count; i++) {
        
        WKBPoint *point1 = [points objectAtIndex:i];
        WKBPoint *point2 = [points objectAtIndex:(i + 1) % points.count];
        
        enum WKBEventType type1 = WKB_ET_RIGHT;
        enum WKBEventType type2 = WKB_ET_LEFT;
        if([WKBSweepLine xyOrderWithPoint:point1 andPoint:point2] == NSOrderedAscending){
            type1 = WKB_ET_LEFT;
            type2 = WKB_ET_RIGHT;
        }
        
        WKBEvent *endpoint1 =  [[WKBEvent alloc] initWithEdge:i andRing:ringIndex andPoint:point1 andType:type1];
        WKBEvent *endpoint2 =  [[WKBEvent alloc] initWithEdge:i andRing:ringIndex andPoint:point2 andType:type2];
        
        [events addObject:endpoint1];
        [events addObject:endpoint2];

    }
    
}

-(NSArray<WKBEvent *> *) events{
    return _events;
}

@end
