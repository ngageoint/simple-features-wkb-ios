//
//  SFWGeometryCodes.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 5/3/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFGeometry.h"

/**
 * Geometry Code utilities to convert between geometry attributes and geometry
 * codes
 */
@interface SFWGeometryCodes : NSObject

/**
 * Get the geometry code from the geometry
 *
 * @param geometry
 *            geometry
 * @return geometry code
 */
+(int) codeFromGeometry: (SFGeometry *) geometry;

/**
 * Get the geometry code from the geometry type
 *
 * @param geometryType
 *            geometry type
 * @return geometry code
 */
+(int) codeFromGeometryType: (enum SFGeometryType) geometryType;

/**
 * Get the Geometry Type from the code
 *
 * @param code
 *            geometry type code
 * @return geometry type
 */
+(enum SFGeometryType) geometryTypeFromCode: (int) code;

/**
 * Determine if the geometry code has a Z (3D) value
 *
 * @param code
 *            geometry code
 * @return true is has Z
 */
+(BOOL) hasZFromCode: (int) code;

/**
 * Determine if the geometry code has a M (linear referencing system) value
 *
 * @param code
 *            geometry code
 * @return true is has M
 */
+(BOOL) hasMFromCode: (int) code;

/**
 * Get the geometry mode from the geometry code. Returns the digit in the
 * thousands place. (z is enabled when 1 or 3, m is enabled when 2 or 3)
 *
 * @param code
 *            geometry code
 * @return geometry mode
 */
+(int) geometryModeFromCode: (int) code;

@end
