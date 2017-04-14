//
//  WKBGeometryEnvelopeBuilder.h
//  wkb-ios
//
//  Created by Brian Osborn on 6/1/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBGeometryEnvelope.h"
#import "WKBGeometry.h"

/**
 *  Builds an envelope from a Geometry
 */
@interface WKBGeometryEnvelopeBuilder : NSObject

/**
 *  Build geometry envelope with geometry
 *
 *  @param geometry geometry to build envelope from
 *
 *  @return geometry envelope
 */
+(WKBGeometryEnvelope *) buildEnvelopeWithGeometry: (WKBGeometry *) geometry;

/**
 *  Expand existing geometry envelope with a geometry
 *
 *  @param envelope envelope to expand
 *  @param geometry geometry to build envelope from
 */
+(void) buildEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry;

/**
 * Build geometry envelope, expanded by wrapping values using the world
 * width producing an envelope longitude range >= (min value - world width)
 * and <= (max value + world width).
 *
 * Example: For WGS84 with longitude values >= -180.0 and <= 180.0, provide
 * a world width of 360.0 resulting in an envelope with longitude range >=
 * -540.0 and <= 540.0.
 *
 * Example: For web mercator with longitude values >= -20037508.342789244
 * and <= 20037508.342789244, provide a world width of 40075016.685578488
 * resulting in an envelope with longitude range >= -60112525.028367732 and
 * <= 60112525.028367732.
 *
 * @param geometry
 *            geometry to build envelope from
 * @param worldWidth
 *            world longitude width in geometry projection
 * @return geometry envelope
 */
+(WKBGeometryEnvelope *) buildEnvelopeWithGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth;

/**
 * Expand existing geometry envelope, expanded by wrapping values using the world
 * width producing an envelope longitude range >= (min value - world width)
 * and <= (max value + world width).
 *
 * Example: For WGS84 with longitude values >= -180.0 and <= 180.0, provide
 * a world width of 360.0 resulting in an envelope with longitude range >=
 * -540.0 and <= 540.0.
 *
 * Example: For web mercator with longitude values >= -20037508.342789244
 * and <= 20037508.342789244, provide a world width of 40075016.685578488
 * resulting in an envelope with longitude range >= -60112525.028367732 and
 * <= 60112525.028367732.
 *
 * @param geometry
 *            geometry to build envelope from
 * @param envelope
 *            envelope to expand
 * @param worldWidth
 *            world longitude width in geometry projection
 */
+(void) buildEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry withWorldWidth: (double) worldWidth;

/**
 *  Initialize
 *
 *  @return new instance
 */
-(instancetype) init;

/**
 *  Initialize
 *
 * If a non nil world width is provided, expansions are done by wrapping
 * values producing an envelope longitude range >= (min value - world width)
 * and <= (max value + world width).
 *
 * Example: For WGS84 with longitude values >= -180.0 and <= 180.0, provide
 * a world width of 360.0 resulting in an envelope with longitude range >=
 * -540.0 and <= 540.0.
 *
 * Example: For web mercator with longitude values >= -20037508.342789244
 * and <= 20037508.342789244, provide a world width of 40075016.685578488
 * resulting in an envelope with longitude range >= -60112525.028367732 and
 * <= 60112525.028367732.
 *
 * @param worldWidth
 *            nil or world longitude width in geometry projection
 */
-(instancetype) initWithWorldWidth: (NSDecimalNumber *) worldWidth;

/**
 * Get the world width
 *
 * @return nil or world longitude width in geometry projection
 */
-(NSDecimalNumber *) worldWidth;

/**
 * Build Geometry Envelope
 *
 * @param geometry
 * @return geometry envelope
 */
-(WKBGeometryEnvelope *) buildWithGeometry: (WKBGeometry *) geometry;

/**
 * Expand Geometry Envelope
 *
 * @param envelope
 * @param geometry
 */
-(void) buildWithEnvelope: (WKBGeometryEnvelope *) envelope andGeometry: (WKBGeometry *) geometry;

@end
