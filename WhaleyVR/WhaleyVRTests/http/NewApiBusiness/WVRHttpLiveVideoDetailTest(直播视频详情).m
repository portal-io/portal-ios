//
//  WVRHttpLiveVideoDetailTest.m
//  WhaleyVR
//  直播视频详情
//  Created by Xie Xiaojian on 2016/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpLiveDetail.h"
@interface WVRHttpLiveVideoDetailTest : XCTestCase

@end

@implementation WVRHttpLiveVideoDetailTest

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
    
    WVRHttpLiveDetail * cmd = [[WVRHttpLiveDetail alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_liveDetail_code] = @"e2999cdaa9b345a7a72020317f0ff7de";
    // e2999cdaa9b345a7a72020317f0ff7de
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpLiveDetailParentModel * data) {
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
