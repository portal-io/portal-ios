//
//  WVRHttpStatUpdateTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpStatUpdate.h"

@interface WVRHttpStatUpdateTest : XCTestCase

@end

@implementation WVRHttpStatUpdateTest

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
    
    WVRHttpStatUpdate * cmd = [[WVRHttpStatUpdate alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_programDetail_srcCode] = @"e3b5939621934f46b66338b028ac1b45";
    httpDic[kHttpParams_programDetail_contentType] = @"vr";
    httpDic[kHttpParams_programDetail_type] = @"view";// timelong
    httpDic[kHttpParams_programDetail_sec] = @"20";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpStatUpdateParentModel * data){
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

