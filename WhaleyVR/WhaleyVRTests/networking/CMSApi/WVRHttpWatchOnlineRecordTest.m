//
//  WVRHttpWatchOnlineRecordTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpWatchOnlineRecord.h"
#import "WVRUserModel.h"

@interface WVRHttpWatchOnlineRecordTest : XCTestCase

@end

@implementation WVRHttpWatchOnlineRecordTest

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

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpWatchOnlineRecord *api = [[WVRHttpWatchOnlineRecord alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kWVRHttp_watchOnline_record_contentType] = @"live";
    params[kWVRHttp_watchOnline_record_code] = @"47f8c74c3da04036942beb364d015a15";
    params[kWVRHttp_watchOnline_record_type] = @"0";
    params[kWVRHttp_watchOnline_record_deviceNo] = [WVRUserModel sharedInstance].deviceId;
    api.bodyParams = params;
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

@end
