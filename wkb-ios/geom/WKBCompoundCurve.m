//
//  WKBCompoundCurve.m
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBCompoundCurve.h"

@implementation WKBCompoundCurve

-(instancetype) init{
    self = [self initWithHasZ:false andHasM:false];
    return self;
}

-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super initWithType:WKB_COMPOUNDCURVE andHasZ:hasZ andHasM:hasM];
    if(self != nil){
        self.lineStrings = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addLineString: (WKBLineString *) lineString{
    [self.lineStrings addObject:lineString];
}

-(NSNumber *) numLineStrings{
    return [NSNumber numberWithInteger:[self.lineStrings count]];
}

-(id) mutableCopyWithZone: (NSZone *) zone{
    WKBCompoundCurve *compoundCurve = [[WKBCompoundCurve alloc] initWithHasZ:self.hasZ andHasM:self.hasM];
    for(WKBLineString *lineString in self.lineStrings){
        [compoundCurve addLineString:[lineString mutableCopy]];
    }
    return compoundCurve;
}

@end
