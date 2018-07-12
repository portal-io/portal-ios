//
//  WVRApiHttpForgotPasswordSMSCodeTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "WVRApiHttpForgotPasswordSMSCode.h"

@interface WVRApiHttpForgotPasswordSMSCodeTest : XCTestCase

@end

@implementation WVRApiHttpForgotPasswordSMSCodeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testForgotPasswordSMSCode {
    WVRApiHttpForgotPasswordSMSCode * cmd = [[WVRApiHttpForgotPasswordSMSCode alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[Params_forgotPWSMSCode_account] = @"15000173801";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(id data){
        NSLog(@"data: %@", data);
    };
    cmd.failedBlock = ^(id data){
        NSLog(@"data: %@", data);
    };
    [cmd loadData];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
