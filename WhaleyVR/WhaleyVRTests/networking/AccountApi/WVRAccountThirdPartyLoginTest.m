//
//  WVRAccountThirdPartyLoginTest.m
//  WhaleyVR
//
//  Created by XIN on 23/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpThirdPartyLogin.h"
#import "WVRUserModel.h"

@interface WVRAccountThirdPartyLoginTest : XCTestCase

@end

@implementation WVRAccountThirdPartyLoginTest

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

- (void)testThirdPartyLogin {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Params_thirdPartyLogin_origin] = @"origin";
    params[Params_thirdPartyLogin_from] = @"whaleyVR";
    params[Params_thirdPartyLogin_device_id] = [WVRUserModel sharedInstance].deviceId;
    params[Params_thirdPartyLogin_open_id] = [WVRUserModel sharedInstance].openIdForBinding;
    params[Params_thirdPartyLogin_nickname] = @"nickname";
    params[Params_thirdPartyLogin_avatar] = @"avatar";
    
    WVRApiHttpThirdPartyLogin *api = [WVRApiHttpThirdPartyLogin new];
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
