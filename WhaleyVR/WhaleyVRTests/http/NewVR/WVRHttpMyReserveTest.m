//
//  WVRHttpMyReserveTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpMyReserve.h"

@interface WVRHttpMyReserveTest : XCTestCase

@end

@implementation WVRHttpMyReserveTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpMyReserve * cmd = [[WVRHttpMyReserve alloc] init];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_myReserveList_uid] = [WVRUserModel sharedInstance].accountId;
    params[kHttpParams_myReserveList_token] = [WVRUserModel sharedInstance].sessionId;
    params[kHttpParams_myReserveList_device_id] = [WVRUserModel sharedInstance].deviceId;
    cmd.bodyParams = params;
    cmd.successedBlock = ^(id  data){
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
