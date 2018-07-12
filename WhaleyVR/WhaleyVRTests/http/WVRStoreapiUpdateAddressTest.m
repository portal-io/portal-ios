//
//  WVRStoreapiUpdateAddressTest.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpUpdateAddress.h"

@interface WVRStoreapiUpdateAddressTest : XCTestCase

@end

@implementation WVRStoreapiUpdateAddressTest

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
    WVRHttpUpdateAddress  * cmd = [WVRHttpUpdateAddress new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_UpdateAddress_whaleyuid] = [[WVRUserModel sharedInstance] accountId];
    params[kHttpParams_UpdateAddress_username] = @"da";
    params[kHttpParams_UpdateAddress_mobile] = @"18877779999";
    params[kHttpParams_UpdateAddress_province] = @"shanggh";
    params[kHttpParams_UpdateAddress_city] = @"hhh";
    params[kHttpParams_UpdateAddress_county] = @"jak";
    params[kHttpParams_UpdateAddress_address] = @"asda";
    cmd.bodyParams = params;
    
    cmd.successedBlock = ^(WVRHttpAddressModel* args){
        [expectation fulfill];
        
    };
    
    cmd.failedBlock = ^(id args){
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
