//
//  WVRAccountSMSTokenTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpSmsToken.h"
#import "WVRUserModel.h"

@interface WVRAccountSMSTokenTest : XCTestCase

@end

@implementation WVRAccountSMSTokenTest

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

- (void)testSMSToken {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Params_smsToken_device_id] = [WVRUserModel sharedInstance].deviceId;
    WVRApiHttpSmsToken *api = [[WVRApiHttpSmsToken alloc] init];
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
