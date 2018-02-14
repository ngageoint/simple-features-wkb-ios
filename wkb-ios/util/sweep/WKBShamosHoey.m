//
//  WKBShamosHoey.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBShamosHoey.h"
#import "WKBGeometryUtils.h"
#import "WKBEventQueue.h"
#import "WKBSweepLine.h"

@implementation WKBShamosHoey

+(BOOL) simplePolygon: (WKBPolygon *) polygon{
    return [self simplePolygonRings:polygon.rings];
}

+(BOOL) simplePolygonPoints: (NSArray<WKBPoint *> *) points{
    WKBLineString *ring = [[WKBLineString alloc] init];
    [ring.points addObjectsFromArray:points];
    return [self simplePolygonRing:ring];
}

+(BOOL) simplePolygonRingPoints: (NSArray<NSArray<WKBPoint *>*> *) pointRings{
    NSMutableArray<WKBLineString *> *rings = [[NSMutableArray alloc] init];
    for(NSArray<WKBPoint *> *points in pointRings){
        WKBLineString *ring = [[WKBLineString alloc] init];
        [ring.points addObjectsFromArray:points];
        [rings addObject:ring];
    }
    return [self simplePolygonRings:rings];
}

+(BOOL) simplePolygonRing: (WKBLineString *) ring{
    NSMutableArray<WKBLineString *> *rings = [[NSMutableArray alloc] init];
    [rings addObject:ring];
    return [self simplePolygonRings:rings];
}

+(BOOL) simplePolygonRings: (NSArray<WKBLineString *> *) rings{
    
    BOOL simple = rings.count > 0;
    
    NSMutableArray<WKBLineString *> *ringCopies = [[NSMutableArray alloc] init];
    for(int i = 0; i < rings.count; i++){
        
        WKBLineString *ring = [rings objectAtIndex:i];
        
        // Copy the ring
        WKBLineString *ringCopy = [[WKBLineString alloc] init];
        [ringCopy.points addObjectsFromArray:ring.points];
        [ringCopies addObject:ringCopy];
        
        // Remove the last point when identical to the first
        NSMutableArray<WKBPoint *> *ringCopyPoints = ringCopy.points;
        if(ringCopyPoints.count >= 3){
            WKBPoint *first = [ringCopyPoints objectAtIndex:0];
            WKBPoint *last = [ringCopyPoints objectAtIndex:ringCopyPoints.count - 1];
            if([first.x compare:last.x] == NSOrderedSame && [first.y compare:last.y] == NSOrderedSame){
                [ringCopyPoints removeObjectAtIndex:ringCopyPoints.count - 1];
            }
        }
        
        // Verify enough ring points
        if (ringCopyPoints.count < 3) {
            simple = NO;
            break;
        }
        
        // Check holes to make sure the first point is in the polygon
        if (i > 0) {
            WKBPoint *firstPoint = [ringCopyPoints objectAtIndex:0];
            if(![WKBGeometryUtils point:firstPoint inPolygonRing:[rings objectAtIndex:0]]){
                simple = NO;
                break;
            }
            // Make sure the hole first points are not inside of one another
            for (int j = 1; j < i; j++) {
                NSArray<WKBPoint *> *holePoints = [rings objectAtIndex:j].points;
                if([WKBGeometryUtils point:firstPoint inPolygonPoints:holePoints]
                   || [WKBGeometryUtils point:[holePoints objectAtIndex:0] inPolygonPoints:ringCopyPoints]){
                    simple = NO;
                    break;
                }
            }
            if (!simple) {
                break;
            }
        }
    }
    
    // If valid polygon rings
    if (simple) {
        
        WKBEventQueue *eventQueue = [[WKBEventQueue alloc] initWithRings:ringCopies];
        WKBSweepLine *sweepLine = [[WKBSweepLine alloc] initWithRings:ringCopies];
        
        for (WKBEvent *event in eventQueue.events) {
            if(event.type == WKB_ET_LEFT){
                WKBSegment *segment = [sweepLine addEvent:event];
                if([sweepLine intersectWithSegment:segment andSegment:segment.above]
                   || [sweepLine intersectWithSegment:segment andSegment:segment.below]){
                    simple = NO;
                    break;
                }
            } else {
                WKBSegment *segment = [sweepLine findEvent:event];
                if([sweepLine intersectWithSegment:segment.above andSegment:segment.below]){
                    simple = NO;
                    break;
                }
                [sweepLine removeSegment:segment];
            }
        }
    }
    
    return simple;
    
}

@end
