//
//  WVRAccountRefreshTokenTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpRefreshToken.h"
#import "WVRUserModel.h"

@interface WVRAccountRefreshTokenTest : XCTestCase

@end

@implementation WVRAccountRefreshTokenTest

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

- (void)testRefreshToken {
    WVRApiHttpRefreshToken * cmd = [[WVRApiHttpRefreshToken alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[refreshToken_refreshtoken] = [WVRUserModel sharedInstance].refreshtoken;
    httpDic[refreshToken_device_id] = [WVRUserModel sharedInstance].deviceId;
    httpDic[refreshToken_accesstoken] = [WVRUserModel sharedInstance].sessionId;
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(id result) {
        NSLog(@"resutl: %@", result);
    };
    cmd.failedBlock = ^(NSString *errMsg) {
        NSLog(@"fail msg: %@",errMsg);
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
