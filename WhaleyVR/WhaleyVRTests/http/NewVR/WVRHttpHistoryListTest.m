//
//  WVRHttpHistoryListTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpHistoryListModel.h"
#import "WVRApiHttpHistoryList.h"
#import "WVRUserModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRApiSignatureGenerator.h"

@interface WVRHttpHistoryListTest : XCTestCase

@end

@implementation WVRHttpHistoryListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[history_list_uid] = [WVRUserModel sharedInstance].accountId;
    params[history_list_device_id] = [WVRUserModel sharedInstance].deviceId;
    params[history_list_page] = @"0";
    params[history_list_size] = @"100";
    params[history_list_dataSource] = @"app";
    
    
    
    WVRApiHttpHistoryList *api = [[WVRApiHttpHistoryList alloc] init];
    api.bodyParams = params;
    api.successedBlock = ^( id data) {
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRModelErrorInfo *error) {
        [expectation fulfill];
    };
    [api loadData];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
