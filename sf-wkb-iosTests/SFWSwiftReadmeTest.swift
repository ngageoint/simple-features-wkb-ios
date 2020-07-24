//
//  SFWSwiftReadmeTest.swift
//  sf-wkb-iosTests
//
//  Created by Brian Osborn on 7/23/20.
//  Copyright © 2020 NGA. All rights reserved.
//

import XCTest

/**
* README example tests
*/
class SFWSwiftReadmeTest: XCTestCase{
    
    static var TEST_GEOMETRY : SFGeometry = SFPoint(xValue: 1.0, andYValue: 1.0)
    static var TEST_BYTES: [Int8] = [0, 0, 0, 0, 1, 63, -16, 0, 0, 0, 0, 0, 0, 63, -16, 0, 0, 0, 0, 0, 0]
    static var TEST_DATA : Data = Data(bytes: TEST_BYTES, count: TEST_BYTES.count)
    
    /**
     * Test read
     */
    func testRead(){
        
        let geometry: SFGeometry = readTester(SFWSwiftReadmeTest.TEST_DATA)
        
        SFWTestUtils.assertEqual(withValue: SFWSwiftReadmeTest.TEST_GEOMETRY, andValue2: geometry)
        
    }
    
    /**
     * Test read
     *
     * @param data
     *            data
     * @return geometry
     */
    func readTester(_ data: Data) -> SFGeometry{
    
        // var data: Data = ...
        
        let geometry: SFGeometry = SFWGeometryReader.readGeometry(with: data)
        let geometryType: SFGeometryType = geometry.geometryType
        
        return geometry
    }
    
    /**
     * Test write
     */
    func testWrite(){
        
        let data: Data = writeTester(SFWSwiftReadmeTest.TEST_GEOMETRY)
        
        SFWGeometryTestUtils.compareData(withExpected: SFWSwiftReadmeTest.TEST_DATA, andActual: data)
        
    }
    
    /**
     * Test write
     *
     * @param geometry
     *            geometry
     * @return data
     */
    func writeTester(_ geometry: SFGeometry) -> Data{
        
        // let geometry: SFGeometry = ...
        
        let data: Data = SFWGeometryWriter.write(geometry)
        
        return data
    }
    
}
