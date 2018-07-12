//
//  WVRHttpFootballListTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpFootballList.h"

@interface WVRHttpFootballListTest : XCTestCase

@end

@implementation WVRHttpFootballListTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testWVRApiHttpAutoArrangeTree {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpFootballList *api = [[WVRHttpFootballList alloc] init];
    
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", data);
        //        [api loadNextPage];
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"Request Failed");
        [expectation fulfill];
    };
    [api loadData];
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}


- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
