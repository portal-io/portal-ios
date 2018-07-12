//
//  WVRHttpLiveOrderList.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/9.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpLiveOrderList.h"
#import "WVRUserModel.h"

@interface WVRHttpLiveOrderListTest : XCTestCase

@end

@implementation WVRHttpLiveOrderListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpLiveOrderList * cmd = [[WVRHttpLiveOrderList alloc] init];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_liveOrderList_uid] = [WVRUserModel sharedInstance].accountId;
    params[kHttpParams_liveOrderList_token] = [WVRUserModel sharedInstance].sessionId;
    params[kHttpParams_liveOrderList_device_id] = [WVRUserModel sharedInstance].deviceId;
    cmd.bodyParams = params;
    cmd.successedBlock = ^(id  data){
        [expectation fulfill];
    };
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
