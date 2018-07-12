//
//  WVRHttpLiveProgramDetailTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpLiveDetails.h"
@interface WVRHttpLiveProgramDetailsTest : XCTestCase

@end

@implementation WVRHttpLiveProgramDetailsTest

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
    
    WVRHttpLiveDetails * cmd = [[WVRHttpLiveDetails alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_liveDetails_code] = @"e2999cdaa9b345a7a72020317f0ff7de-60ed4b7cba364354b2aa3c21e099641a";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpLiveDetailsParentModel * data){
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
