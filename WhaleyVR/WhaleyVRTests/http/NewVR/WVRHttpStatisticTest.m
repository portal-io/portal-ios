//
//  WVRHttpStatisticTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpStatistic.h"

@interface WVRHttpStatisticTest : XCTestCase

@end

@implementation WVRHttpStatisticTest

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
    
    WVRHttpStatistic * cmd = [[WVRHttpStatistic alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_statistic_id] = @"1000";
    httpDic[kHttpParams_statistic_ip] = @"192.1681.1.1";
    httpDic[kHttpParams_statistic_model] = @"1000";
    httpDic[kHttpParams_statistic_type] = @"1";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpStatisticModel * data){
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
