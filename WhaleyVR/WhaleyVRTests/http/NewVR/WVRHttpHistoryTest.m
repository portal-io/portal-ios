//
//  WVRHttpHistoryTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpHistoryRecord.h"
#import "WVRModelErrorInfo.h"
#import "WVRUserModel.h"
#import "WVRApiSignatureGenerator.h"

@interface WVRHttpHistoryTest : XCTestCase

@end

@implementation WVRHttpHistoryTest

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
    params[history_record_uid] = [WVRUserModel sharedInstance].accountId;
    params[history_record_device_id] = [WVRUserModel sharedInstance].deviceId;
    params[history_record_playTime] = @"100";
    params[history_record_playStatus] = @"1";
    params[history_record_programCode] = @"5b6872b22c404752b4ca70414eaf9900";
    params[history_record_programType] = @"program";
    params[history_record_dataSource] = @"app";
    params[history_record_totalPlayTime] = @"10000";
    
    
    
    WVRApiHttpHistoryRecord *api = [[WVRApiHttpHistoryRecord alloc] init];
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
