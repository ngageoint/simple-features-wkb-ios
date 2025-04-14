//
//  SFWBGeometryTypeInfo.h
//  sf-wkb-ios
//
//  Created by Brian Osborn on 5/3/18.
//  Copyright © 2018 NGA. All rights reserved.
//

@import sf_ios;

/**
 * Geometry type info
 */
@interface SFWBGeometryTypeInfo : NSObject

/**
 * Initializer
 *
 * @param geometryTypeCode
 *            geometry type code
 * @param geometryType
 *            geometry type
 * @param hasZ
 *            has z
 * @param hasM
 *            has m
 */
-(instancetype) initWithCode: (int) geometryTypeCode andType: (SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Get the geometry type code
 *
 * @return geometry type code
 */
-(int) geometryTypeCode;

/**
 * Get the geometry type
 *
 * @return geometry type
 */
-(SFGeometryType) geometryType;

/**
 * Has z values
 *
 * @return true if has z values
 */
-(BOOL) hasZ;

/**
 * Has m values
 *
 * @return true if has m values
 */
-(BOOL) hasM;

@end
