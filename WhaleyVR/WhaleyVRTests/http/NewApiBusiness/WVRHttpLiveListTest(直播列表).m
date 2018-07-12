//
//  WVRHttpLiveListTest.m
//  WhaleyVR
//  直播列表(即将直播和正在直播)
//  Created by Xie Xiaojian on 2016/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpLiveList.h"
@interface WVRHttpLiveListTest : XCTestCase

@end

@implementation WVRHttpLiveListTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultiDetail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpLiveList * cmd = [[WVRHttpLiveList alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_liveList_liveStatus] = @"0";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpLiveListParentModel * data) {
        [expectation fulfill];
    };
    cmd.failedBlock = ^(NSString* errMsg) {
        NSLog(@"fail msg: %@", errMsg);
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
