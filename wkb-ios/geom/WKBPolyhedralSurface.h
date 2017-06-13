//
//  WKBPolyhedralSurface.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/2/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "WKBSurface.h"
#import "WKBPolygon.h"

/**
 *  Contiguous collection of polygons which share common boundary segments.
 */
@interface WKBPolyhedralSurface : WKBSurface

/**
 *  Array of polygons
 */
@property (nonatomic, strong) NSMutableArray * polygons;

/**
 *  Initialize
 *
 *  @return new polyhedral surface
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param hasZ has z values
 *  @param hasM has m values
 *
 *  @return new polyhedral surface
 */
-(instancetype) initWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Initialize
 *
 *  @param geometryType geometry type
 *  @param hasZ         has z values
 *  @param hasM         has m values
 *
 *  @return new polyhedral surface
 */
-(instancetype) initWithType: (enum WKBGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Add a polygon
 *
 *  @param polygon polygon
 */
-(void) addPolygon: (WKBPolygon *) polygon;

/**
 *  Get the number of polygons
 *
 *  @return polygon count
 */
-(NSNumber *) numPolygons;

@end
