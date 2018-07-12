
//
//  WVRHttpPayStatusTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/30.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpPayStatus.h"
@interface WVRHttpPayStatusTest:XCTestCase
@end
@implementation WVRHttpPayStatusTest


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    WVRHttpPayStatus *cmd = [[WVRHttpPayStatus alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[K_ORDER_NO] = @"1342111111";
    httpDic[K_VERSION] = @"1.1";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpPayStatusModel * data){
        [expectation fulfill];
    };
    
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}
@end
