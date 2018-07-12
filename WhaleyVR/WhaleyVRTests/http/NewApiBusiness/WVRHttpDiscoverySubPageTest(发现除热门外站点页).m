//
//  WVRHttpDiscoverySubPageTest.m
//  WhaleyVR
//  发现页面的子页面（不包括第一个“热门”页面）
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "WVRHtttpRecommendPage.h"

@interface WVRHttpDiscoverySubPageTest : XCTestCase

@end

@implementation WVRHttpDiscoverySubPageTest

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
    
    WVRHtttpRecommendPage * cmd = [[WVRHtttpRecommendPage alloc] init];
    //    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    cmd.code= @"vr_video";
    //    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpRecommendPageDetailParentModel * data) {
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
