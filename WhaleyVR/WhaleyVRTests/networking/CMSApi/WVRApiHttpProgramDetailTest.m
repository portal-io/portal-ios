//
//  WVRApiHttpProgramDetailTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpProgramDetail.h"

@interface WVRApiHttpProgramDetailTest : XCTestCase

@end

@implementation WVRApiHttpProgramDetailTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWVRApiHttpProgramDetail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRApiHttpProgramDetail *api = [[WVRApiHttpProgramDetail alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kWVRAPIParamsProgramDetailCode] = @"test";
    api.bodyParams = params;
//    api.urlParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", data);
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"Request Failed");
        [expectation fulfill];
    };
    [api loadData];
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
