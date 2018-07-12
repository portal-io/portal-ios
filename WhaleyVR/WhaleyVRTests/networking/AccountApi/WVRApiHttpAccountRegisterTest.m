//
//  WVRApiHttpAccountRegisterTest.m
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpRegister.h"
#import "WVRUserModel.h"
#import "WVRModelUserInfo.h"
#import "WVRModelErrorInfo.h"

@interface WVRApiHttpAccountRegisterTest : XCTestCase

@end

@implementation WVRApiHttpAccountRegisterTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWVRApiHttpAccountRegister {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[sms_register_device_id] = [WVRUserModel sharedInstance].deviceId;
    params[sms_register_code] = @"330757";
    params[sms_register_mobile] = @"18616718890";
    params[sms_register_ncode] = @"86";
    params[sms_register_from] = @"whaleyVR";
    
    WVRApiHttpRegister *registerApi = [[WVRApiHttpRegister alloc] init];
    registerApi.bodyParams = params;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectation should success"];

    registerApi.successedBlock = ^(WVRModelUserInfo *data){
        [expectation fulfill];
        NSLog(@"%@", data);
    };
    
    registerApi.failedBlock = ^(WVRModelErrorInfo *data){
        [expectation fulfill];
        NSLog(@"%@", data);
    };
    [registerApi loadData];
    
    [self waitForExpectationsWithTimeout:100 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
