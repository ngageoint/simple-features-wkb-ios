//
//  SFWBGeometryCodes.m
//  sf-wkb-ios
//
//  Created by Brian Osborn on 5/3/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "SFWBGeometryCodes.h"
#import "SFLineString.h"
#import "SFCircularString.h"
#import "SFMultiLineString.h"

@implementation SFWBGeometryCodes

+(int) codeFromGeometry: (SFGeometry *) geometry{
    return [self codeFromGeometryType:geometry.geometryType andHasZ:geometry.hasZ andHasM:geometry.hasM];
}

+(int) codeFromGeometryType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    int code = [self codeFromGeometryType:geometryType];
    if (hasZ) {
        code += 1000;
    }
    if (hasM) {
        code += 2000;
    }
    return code;
}

+(int) codeFromGeometryType: (enum SFGeometryType) geometryType{
    
    int code;
    
    switch (geometryType) {
        case SF_GEOMETRY:
            code = 0;
            break;
        case SF_POINT:
            code = 1;
            break;
        case SF_LINESTRING:
            code = 2;
            break;
        case SF_POLYGON:
            code = 3;
            break;
        case SF_MULTIPOINT:
            code = 4;
            break;
        case SF_MULTILINESTRING:
            code = 5;
            break;
        case SF_MULTIPOLYGON:
            code = 6;
            break;
        case SF_GEOMETRYCOLLECTION:
            code = 7;
            break;
        case SF_CIRCULARSTRING:
            code = 8;
            break;
        case SF_COMPOUNDCURVE:
            code = 9;
            break;
        case SF_CURVEPOLYGON:
            code = 10;
            break;
        case SF_MULTICURVE:
            code = 11;
            break;
        case SF_MULTISURFACE:
            code = 12;
            break;
        case SF_CURVE:
            code = 13;
            break;
        case SF_SURFACE:
            code = 14;
            break;
        case SF_POLYHEDRALSURFACE:
            code = 15;
            break;
        case SF_TIN:
            code = 16;
            break;
        case SF_TRIANGLE:
            code = 17;
            break;
        default:
            [NSException raise:@"Unsupported Geometry Type" format:@"Unsupported Geometry Type for code retrieval: %u", geometryType];
    }
    
    return code;
}

+(int) wkbCodeFromGeometry: (SFGeometry *) geometry{
    return [self codeFromGeometryType:[self wkbGeometryTypeFromGeometry:geometry] andHasZ:geometry.hasZ andHasM:geometry.hasM];
}

+(enum SFGeometryType) wkbGeometryTypeFromGeometry: (SFGeometry *) geometry{
    enum SFGeometryType type = geometry.geometryType;
    if(![geometry isEmpty]){
        switch (type){
            case SF_MULTILINESTRING:
                {
                    SFLineString *lineString = [((SFMultiLineString *) geometry) lineStringAtIndex:0];
                    if([lineString isKindOfClass:[SFCircularString class]]){
                        type = SF_MULTICURVE;
                    }
                }
                break;
            default:
                break;
        }
    }
    return type;
}

+(enum SFGeometryType) geometryTypeFromCode: (int) code{
    
    // Look at the last 2 digits to find the geometry type code
    int geometryTypeCode = code % 1000;
    
    enum SFGeometryType geometryType;
    
    switch (geometryTypeCode) {
        case 0:
            geometryType = SF_GEOMETRY;
            break;
        case 1:
            geometryType = SF_POINT;
            break;
        case 2:
            geometryType = SF_LINESTRING;
            break;
        case 3:
            geometryType = SF_POLYGON;
            break;
        case 4:
            geometryType = SF_MULTIPOINT;
            break;
        case 5:
            geometryType = SF_MULTILINESTRING;
            break;
        case 6:
            geometryType = SF_MULTIPOLYGON;
            break;
        case 7:
            geometryType = SF_GEOMETRYCOLLECTION;
            break;
        case 8:
            geometryType = SF_CIRCULARSTRING;
            break;
        case 9:
            geometryType = SF_COMPOUNDCURVE;
            break;
        case 10:
            geometryType = SF_CURVEPOLYGON;
            break;
        case 11:
            geometryType = SF_MULTICURVE;
            break;
        case 12:
            geometryType = SF_MULTISURFACE;
            break;
        case 13:
            geometryType = SF_CURVE;
            break;
        case 14:
            geometryType = SF_SURFACE;
            break;
        case 15:
            geometryType = SF_POLYHEDRALSURFACE;
            break;
        case 16:
            geometryType = SF_TIN;
            break;
        case 17:
            geometryType = SF_TRIANGLE;
            break;
        default:
            [NSException raise:@"Unsupported Geometry Code" format:@"Unsupported Geometry code for type retrieval: %u", code];
    }
    
    return geometryType;
}

+(BOOL) hasZFromCode: (int) code{
    
    BOOL hasZ = NO;
    
    int mode = [self geometryModeFromCode:code];
    
    switch (mode) {
        case 0:
        case 2:
            break;
        case 1:
        case 3:
            hasZ = YES;
            break;
        default:
            [NSException raise:@"Unexpected Geometry Code" format:@"Unexpected Geometry code for Z determination: %u", code];
    }
    
    return hasZ;
}

+(BOOL) hasMFromCode: (int) code{
    
    BOOL hasM = NO;
    
    int mode = [self geometryModeFromCode:code];
    
    switch (mode) {
        case 0:
        case 1:
            break;
        case 2:
        case 3:
            hasM = YES;
            break;
        default:
            [NSException raise:@"Unexpected Geometry Code" format:@"Unexpected Geometry code for M determination: %u", code];
    }
    
    return hasM;
}

+(int) geometryModeFromCode: (int) code{
    return code / 1000;
}

@end
