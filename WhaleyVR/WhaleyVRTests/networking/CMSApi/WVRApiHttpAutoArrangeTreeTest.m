//
//  WVRApiHttpAutoArrangeTreeTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpAutoArrange.h"

@interface WVRApiHttpAutoArrangeTreeTest : XCTestCase
@property NSInteger flag;
@end

@implementation WVRApiHttpAutoArrangeTreeTest

- (void)setUp {
    [super setUp];
    self.flag = 0;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWVRApiHttpAutoArrangeTree {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRApiHttpAutoArrange *api = [[WVRApiHttpAutoArrange alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kWVRAPIParams_AutoArrange_Code] = @"360_xingesheng";
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

- (void)testWVRApiHttpAutoArrangeTreeCache {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRApiHttpAutoArrange *api = [[WVRApiHttpAutoArrange alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kWVRAPIParams_AutoArrange_Code] = @"360_xingesheng";
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", data);
//        if (self.flag > 0) {
//            [expectation fulfill];
//        }
//        [api loadData];
//        self.flag++;
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
