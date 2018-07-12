//
//  WVRApiHttpAccountChangePasswordTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpChangePassword.h"
#import "WVRUserModel.h"

@interface WVRApiHttpAccountChangePasswordTest : XCTestCase

@end

@implementation WVRApiHttpAccountChangePasswordTest

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

- (void)testChangePassword {
    WVRApiHttpChangePassword * cmd = [[WVRApiHttpChangePassword alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[Params_changePW_device_id] = [WVRUserModel sharedInstance].deviceId;
    httpDic[Params_changePW_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    httpDic[Params_changePW_password] = @"newpassword";
    httpDic[Params_changePW_old_pwd] = @"oldpassword";
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
