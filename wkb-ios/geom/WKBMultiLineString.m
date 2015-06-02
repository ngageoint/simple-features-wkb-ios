//
//  WKBMultiLineString.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBMultiLineString.h"

@implementation WKBMultiLineString

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_MULTILINESTRING andHasZ:hasZ andHasM:hasM];
    return self;
}

-(NSMutableArray *) getLineStrings{
    return [self geometries];
}

-(void) setLineStrings: (NSMutableArray *) lineStrings{
    [self setGeometries:lineStrings];
}

-(void) addLineString: (WKBLineString *) lineString{
    [self addGeometry:lineString];
}

-(NSNumber *) numLineStrings{
    return [self numGeometries];
}

@end
