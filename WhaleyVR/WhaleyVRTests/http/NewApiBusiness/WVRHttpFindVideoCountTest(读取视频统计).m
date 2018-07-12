//
//  WVRHttpFindVideoCountTest.m
//  WhaleyVR
//  查询视频统计信息
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpFindStat.h"

@interface WVRHttpFindVideoCountTest : XCTestCase

@end

@implementation WVRHttpFindVideoCountTest

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
    
    WVRHttpFindStat * cmd = [[WVRHttpFindStat alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_findStat_srcCode] = @"e3b5939621934f46b66338b028ac1b45";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpFindStatParentModel * data) {
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

