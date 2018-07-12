//
//  HttpWALoginTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/20.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpLogin.h"

@interface HttpWALoginTest : XCTestCase

@end

@implementation HttpWALoginTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self httpLoginDirectUserName:@"13817425147" passWord:@"whaley123" from:@"whaleyVR"];
}

- (void)httpLoginDirectUserName:(NSString*)phoneNum passWord:(NSString*)passWord from:(NSString*)from{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpLogin * cmd = [[WVRHttpLogin alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_login_direct_username] = phoneNum;
    httpDic[kHttpParams_login_direct_password] = passWord;
    httpDic[kHttpParams_login_direct_from] = from;
    //    httpDic[kHttpParams_login_direct_device_id] = [WVRUserModel sharedInstance].deviceId;
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpUserModel * data){
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

@end
