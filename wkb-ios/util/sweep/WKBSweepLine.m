//
//  WKBSweepLine.m
//  wkb-ios
//
//  Created by Brian Osborn on 1/12/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "WKBSweepLine.h"

@interface WKBSweepLine()

/**
 * Polygon rings
 */
@property (nonatomic, strong) NSArray<WKBLineString *> *rings;

/**
 * Tree of segments sorted by above-below order
 * TODO performance could be improved with a Red-Black or AVL tree
 */
@property NSMutableOrderedSet<WKBSegment *> *tree;

/**
 * Mapping between ring, edges, and segments
 */
@property NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, WKBSegment *> *> * segments;

@end

@implementation WKBSweepLine

-(instancetype) initWithRings: (NSArray<WKBLineString *> *) rings{
    self = [super init];
    if(self != nil){
        self.rings = rings;
        self.tree = [[NSMutableOrderedSet alloc] init];
        self.segments = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(WKBSegment *) addEvent: (WKBEvent *) event{
    
    WKBSegment *segment = [self createSegmentForEvent:event];
    
    // Add to the tree
    int insertLocation = [self locationOfSegment:segment atX:[event.point.x doubleValue]];
    [self.tree insertObject:segment atIndex:insertLocation];
    
    // Update the above and below pointers
    WKBSegment *next = [self higherSegment:insertLocation];
    WKBSegment *previous = [self lowerSegment:insertLocation];
    if (next != nil) {
        segment.above = next;
        next.below = segment;
    }
    if (previous != nil) {
        segment.below = previous;
        previous.above = segment;
    }
    
    // Add to the segments map
    NSNumber *ringNumber = [NSNumber numberWithInt:segment.ring];
    NSMutableDictionary<NSNumber *, WKBSegment *> *edgeDictionary = [self.segments objectForKey:ringNumber];
    if (edgeDictionary == nil) {
        edgeDictionary = [[NSMutableDictionary alloc] init];
        [self.segments setObject:edgeDictionary forKey:ringNumber];
    }
    [edgeDictionary setObject:segment forKey:[NSNumber numberWithInt:segment.edge]];
    
    return segment;
}

/**
 * Get the location where the segment should be inserted or is located
 *
 * @param segment
 *            segment
 * @param x
 *            x value
 * @return index location
 */
-(int) locationOfSegment: (WKBSegment *) segment atX: (double) x{
    
    NSUInteger insertLocation = [self.tree indexOfObject:segment inSortedRange:NSMakeRange(0, self.tree.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(WKBSegment * segment1, WKBSegment * segment2){
        
        double y1 = [self yValueAtX:x forSegment:segment1];
        double y2 = [self yValueAtX:x forSegment:segment2];
        
        NSComparisonResult compare;
        if (y1 < y2) {
            compare = NSOrderedAscending;
        } else if (y2 < y1) {
            compare = NSOrderedDescending;
        } else if (segment1.ring < segment2.ring) {
            compare = NSOrderedAscending;
        } else if (segment2.ring < segment1.ring) {
            compare = NSOrderedDescending;
        } else if (segment1.edge < segment2.edge) {
            compare = NSOrderedAscending;
        } else if (segment2.edge < segment1.edge) {
            compare = NSOrderedDescending;
        } else {
            compare = NSOrderedSame;
        }
        
        return compare;
    }];
    
    return (int)insertLocation;
}

/**
 * Get the segment lower than the location
 *
 * @param location
 *            segment location
 * @return lower segment
 */
-(WKBSegment *) lowerSegment: (int) location{
    WKBSegment * lower = nil;
    if(location - 1 > 0){
        lower = [self.tree objectAtIndex:location - 1];
    }
    return lower;
}

/**
 * Get the segment higher than the location
 *
 * @param location
 *            segment location
 * @return higher segment
 */
-(WKBSegment *) higherSegment: (int) location{
    WKBSegment * higher = nil;
    if(location + 1 < self.tree.count){
        higher = [self.tree objectAtIndex:location + 1];
    }
    return higher;
}

/**
 * Create a segment from the event
 *
 * @param event
 *            event
 * @return segment
 */
-(WKBSegment *) createSegmentForEvent: (WKBEvent *) event{

    int edgeNumber = event.edge;
    int ringNumber = event.ring;
    
    WKBLineString *ring = [self.rings objectAtIndex:ringNumber];
    NSArray<WKBPoint *> *points = ring.points;
    
    WKBPoint *point1 = [points objectAtIndex:edgeNumber];
    WKBPoint *point2 = [points objectAtIndex:(edgeNumber + 1) % points.count];
    
    WKBPoint *left = nil;
    WKBPoint *right = nil;
    if([WKBSweepLine xyOrderWithPoint:point1 andPoint:point2] == NSOrderedAscending){
        left = point1;
        right = point2;
    } else {
        right = point1;
        left = point2;
    }
    
    WKBSegment *segment = [[WKBSegment alloc] initWithEdge:edgeNumber andRing:ringNumber andLeftPoint:left andRightPoint:right];
    
    return segment;
}

-(WKBSegment *) findEvent: (WKBEvent *) event{
    return [[self.segments objectForKey:[NSNumber numberWithInt:event.ring]] objectForKey:[NSNumber numberWithInt:event.edge]];
}

-(BOOL) intersectWithSegment: (WKBSegment *) segment1 andSegment: (WKBSegment *) segment2{

    BOOL intersect = NO;
    
    if (segment1 != nil && segment2 != nil) {
        
        int ring1 = segment1.ring;
        int ring2 = segment2.ring;
        
        BOOL consecutive = ring1 == ring2;
        if (consecutive) {
            int edge1 = segment1.edge;
            int edge2 = segment2.edge;
            int ringPoints = [[[self.rings objectAtIndex:ring1] numPoints] intValue];
            consecutive = (edge1 + 1) % ringPoints == edge2
                || edge1 == (edge2 + 1) % ringPoints;
        }
        
        if (!consecutive) {
            
            double left = [WKBSweepLine isPoint:segment2.leftPoint leftOfSegment:segment1];
            double right = [WKBSweepLine isPoint:segment2.rightPoint leftOfSegment:segment1];
            
            if (left * right <= 0) {
                
                left = [WKBSweepLine isPoint:segment1.leftPoint leftOfSegment:segment2];
                right = [WKBSweepLine isPoint:segment1.rightPoint leftOfSegment:segment2];
                
                if (left * right <= 0) {
                    intersect = YES;
                }
            }
        }
    }
    
    return intersect;
}

-(void) removeSegment: (WKBSegment *) segment{

    BOOL removed = [self removeSegment:segment atX:[segment.rightPoint.x doubleValue]];
    if (!removed) {
        removed = [self removeSegment:segment atX:[segment.leftPoint.x doubleValue]];
    }
    
    if (removed) {
        
        WKBSegment *above = segment.above;
        WKBSegment *below = segment.below;
        if (above != nil) {
            above.below = below;
        }
        if (below != nil) {
            below.above = above;
        }
        
        [[self.segments objectForKey:[NSNumber numberWithInt:segment.ring]] removeObjectForKey:[NSNumber numberWithInt:segment.edge]];
    }
}

/**
 * Remove the segment from the tree using the x value
 *
 * @param segment
 *            segment
 * @param x
 *            value
 * @return true if removed
 */
-(BOOL) removeSegment: (WKBSegment *) segment atX: (double) x{
    
    BOOL removed = NO;
    
    int location = [self locationOfSegment:segment atX:x];
    if(location < self.tree.count){
        WKBSegment *treeSegment = [self.tree objectAtIndex:location];
        if([treeSegment isEqual:segment]){
            [self.tree removeObjectAtIndex:location];
            removed = YES;
        }
    }
    
    return removed;
}

/**
 * Get the segment y value at the x location by calculating the line slope
 *
 * @param x
 *            current point x value
 * @param segment
 *            segment
 *
 * @return segment y value
 */
-(double) yValueAtX: (double) x forSegment: (WKBSegment *) segment{
    
    WKBPoint *left = segment.leftPoint;
    WKBPoint *right = segment.rightPoint;
    
    double m = ([right.y doubleValue] - [left.y doubleValue]) / ([right.x doubleValue] - [left.x doubleValue]);
    double b = [left.y doubleValue] - (m * [left.x doubleValue]);
    
    double y = (m * x) + b;
    
    return y;
}

+(NSComparisonResult) xyOrderWithPoint: (WKBPoint *) point1 andPoint: (WKBPoint *) point2{
    NSComparisonResult value = NSOrderedSame;
    if ([point1.x doubleValue] > [point2.x doubleValue]) {
        value = NSOrderedDescending;
    } else if ([point1.x doubleValue] < [point2.x doubleValue]) {
        value = NSOrderedAscending;
    } else if ([point1.y doubleValue] > [point2.y doubleValue]) {
        value = NSOrderedDescending;
    } else if ([point1.y doubleValue] < [point2.y doubleValue]) {
        value = NSOrderedAscending;
    }
    return value;
}

/**
 * Check where the point is (left, on, right) relative to the line segment
 *
 * @param point
 *            point
 * @param segment
 *            segment
 * @return > 0 if left, 0 if on, < 0 if right
 */
+(double) isPoint: (WKBPoint *) point leftOfSegment: (WKBSegment *) segment{
    return [self isPoint:point leftOfPoint1:segment.leftPoint toPoint2:segment.rightPoint];
}

/**
 * Check where point is (left, on, right) relative to the line from point 1 to point 2
 *
 * @param point
 *            point
 * @param point1
 *            point 1
 * @param point2
 *            point 2
 * @return > 0 if left, 0 if on, < 0 if right
 */
+(double) isPoint: (WKBPoint *) point leftOfPoint1: (WKBPoint *) point1 toPoint2: (WKBPoint *) point2{
    return ([point2.x doubleValue] - [point1.x doubleValue])
    * ([point.y doubleValue] - [point1.y doubleValue])
    - ([point.x doubleValue] - [point1.x doubleValue])
    * ([point2.y doubleValue] - [point1.y doubleValue]);
}

@end
