//
//  TestLoggerAsync.swift
//  MikCore_Tests
//
//  Created by ty on 2022/2/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import MikCore

class TestLoggerAsync: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.

        }
    }


    func testAsynchronousLog() {


//        let expectation = expectation(description: "test log concurrent")

//        ///该方法实现了一个高效的并行循环。
//        DispatchQueue.concurrentPerform(iterations: 1000) { (idx) in
//            MikLogger.info("test message \(idx)")
//        }

        print("for loop begin")

//        for i in 0...1000 {
//            MikLogger.debug("test message \(i)", ["debugKey" : "debugValue"])
//            MikLogger.info("test message \(i)", ["infoKey" : i])
//            MikLogger.warn("test message \(i)", ["warnKey" : ["warnKey2" : "warnKey2Value"]])
//            MikLogger.error("test message \(i)", ["errorKey": ["\(i)"]])
//        }

        print("for loop end")

//        expectation.fulfill()
//
//        waitForExpectations(timeout: 10, handler: nil)
//
//        print("wait log end")
    }

}
