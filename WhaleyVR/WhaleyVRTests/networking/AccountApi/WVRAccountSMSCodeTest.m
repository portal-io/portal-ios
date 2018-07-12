//
//  WVRAccountSMSCodeTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpSmsCode.h"
#import "WVRUserModel.h"

@interface WVRAccountSMSCodeTest : XCTestCase

@end

@implementation WVRAccountSMSCodeTest

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

- (void)testSMSCode {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[sms_login_device_id] = [WVRUserModel sharedInstance].sms_token;
    params[sms_login_sms_token] = [WVRUserModel sharedInstance].sms_token;
    params[sms_login_mobile] = @"15000173801";
    params[sms_login_ncode] = @"86";
    params[sms_login_captcha] = @"";
    
    WVRApiHttpSmsCode *api = [[WVRApiHttpSmsCode alloc] init];
    api.bodyParams = params;
    
    api.successedBlock = ^(id data) {
        NSLog(@"data: %@", data);
    };
    
    api.failedBlock = ^(id data) {
        NSLog(@"data: %@", data);
    };
    
    [api loadData];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
