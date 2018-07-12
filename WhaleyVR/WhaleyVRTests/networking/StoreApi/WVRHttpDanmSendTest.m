//
//  WVRHttpDanmSendTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WVRApiHttpDanmuSend.h"
@interface WVRHttpDanmSendTest : XCTestCase

@end

@implementation WVRHttpDanmSendTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testSendDanm {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
  
    WVRApiHttpDanmuSend *api = [[WVRApiHttpDanmuSend alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kWVRAPIParamsDanmuSend_roomid] = @"1";
    params[kWVRAPIParamsDanmuSend_message] = @"hhhhh";
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", [data contentString]);
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
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
