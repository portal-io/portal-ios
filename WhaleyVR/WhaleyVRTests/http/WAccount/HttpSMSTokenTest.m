//
//  HttpSMSTokenTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/20.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpSMSToken.h"
#import "WVRUserModel.h"

@interface HttpSMSTokenTest : XCTestCase

@end

@implementation HttpSMSTokenTest

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
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpSMSToken * cmd = [[WVRHttpSMSToken alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_smsToken_device_id] = [WVRUserModel sharedInstance].deviceId;
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpSMSTokenModel * data){
//        [WVRUserModel sharedInstance].sessionId = data.sms_token;
        [expectation fulfill];
    };
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];

}

- (NSString *)idfaId
{
    NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
    NSString * currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
    currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
    return currentDeviceUUIDStr;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
