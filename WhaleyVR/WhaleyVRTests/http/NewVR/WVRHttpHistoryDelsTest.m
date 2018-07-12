//
//  WVRHttpHistoryDelsTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpHistoryDels.h"
#import "WVRUserModel.h"
#import "WVRModelErrorInfo.h"
#import "WVRApiSignatureGenerator.h"

@interface WVRHttpHistoryDelsTest : XCTestCase

@end

@implementation WVRHttpHistoryDelsTest

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
    params[history_dels_dataSource] = @"app";
    params[history_dels_uid] = [WVRUserModel sharedInstance].accountId;
    params[history_dels_deviceId] = [WVRUserModel sharedInstance].deviceId;
    params[history_dels_delIds] = @"612,613";
    
//    NSString * signStr = [@"app" stringByAppendingString:[[[[WVRUserModel sharedInstance].accountId stringByAppendingString:[WVRUserModel sharedInstance].deviceId] stringByAppendingString:@"612,613"] stringByAppendingString:TEST_USER_HISTORY_SIGN_SECRET]];
//    params[history_dels_sign] = [WVRApiSignatureGenerator signPostWithApiParamsValues:signStr privateKey:@"" publicKey:TEST_USER_HISTORY_SIGN_SECRET];
//    
    WVRApiHttpHistoryDels *api = [[WVRApiHttpHistoryDels alloc] init];
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
