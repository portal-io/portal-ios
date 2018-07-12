//
//  WVRStoreapiGetAddressTest.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpGetAddress.h"

@interface WVRStoreapiGetAddressTest : XCTestCase

@end

@implementation WVRStoreapiGetAddressTest

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
    WVRHttpGetAddress  * cmd = [WVRHttpGetAddress new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[kHttpParams_getAddress_whaleyuid] = [[WVRUserModel sharedInstance] accountId];
    
    cmd.bodyParams = params;
    
    cmd.successedBlock = ^(WVRHttpAddressModel* args){
        [expectation fulfill];
    };
    
    cmd.failedBlock = ^(id args){
        [expectation fulfill];
    };
    [cmd execute];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
