//
//  HttpSMSCodeTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/20.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpSMSCode.h"
#import "WVRUserModel.h"

@interface HttpSMSCodeTest : XCTestCase

@end

@implementation HttpSMSCodeTest

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
    
    WVRHttpSMSCode * cmd = [[WVRHttpSMSCode alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_sms_login_device_id] = [WVRUserModel sharedInstance].deviceId;//@"b6e7bcd3cd5d4fb2a96d76c670f02a35";//[self deviceId];
    httpDic[kHttpParams_sms_login_sms_token] = @"b49a3f72b1f5d469c31754c369a74912";//[WVRUserModel sharedInstance].sessionId;
    httpDic[kHttpParams_sms_login_mobile] = @"18616718890";
    httpDic[kHttpParams_sms_login_ncode] = @"86";
//    httpDic[kHttpParams_sms_login_captcha] = @"bee34b9a58aa09768744187627285bc7";
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(NSString * data){
        NSLog(@"success response: %@",[data yy_modelToJSONString]);
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
