//
//  WVRApiHttpHomeTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpHome.h"
#import <AFNetworking/AFNetworking.h>
#import "WVRModelRecommend.h"

@interface WVRApiHttpHomeTest : XCTestCase

@end

@implementation WVRApiHttpHomeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWVRApiHttpHome {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRApiHttpHome *api = [[WVRApiHttpHome alloc] init];
    api.successedBlock = ^(WVRModelRecommend *data) {
        NSLog(@"%@", data);
        NSAssert(data.id, @"id is null, maybe data is null");
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", data);
        [expectation fulfill];
    };
    [api loadData];
    NSInteger requestId = [api loadData];
//    [api cancelRequestWithRequestId:requestId];
//    [api cancelAllRequests];
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
