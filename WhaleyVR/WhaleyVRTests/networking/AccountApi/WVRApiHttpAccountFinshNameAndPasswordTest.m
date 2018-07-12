//
//  WVRApiHttpAccountFinshNameAndPasswordTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpFinishNamePassword.h"
#import "WVRUserModel.h"

@interface WVRApiHttpAccountFinshNameAndPasswordTest : XCTestCase

@end

@implementation WVRApiHttpAccountFinshNameAndPasswordTest

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

- (void)testFinishNameAndPassword {
    NSString *deviceId = [WVRUserModel sharedInstance].deviceId;
    NSString *nickName = @"nickname";
    NSString *password = @"newpassword";
    WVRApiHttpFinishNamePassword * cmd = [[WVRApiHttpFinishNamePassword alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[Params_finishNamePW_nickname] = nickName;
    httpDic[Params_finishNamePW_password] = password;
    httpDic[Params_finishNamePW_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    httpDic[Params_finishNamePW_device_id] = deviceId;
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(id data) {
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
