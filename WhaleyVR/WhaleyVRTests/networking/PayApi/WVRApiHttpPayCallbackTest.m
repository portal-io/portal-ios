//
//  WVRApiHttpPayCallbackTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpPayCallback.h"
#import "WVRGlobalUtil.h"
#import "WVRUserModel.h"


@interface WVRApiHttpPayCallbackTest : XCTestCase

@end

@implementation WVRApiHttpPayCallbackTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPayCallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    WVRApiHttpPayCallback *api = [[WVRApiHttpPayCallback alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kHttpParam_PayCallback_orderNo] = @"orderno_8aa0a22de40f4272972e4141e00366b3";
    params[kHttpParam_PayCallback_payMethod] = @"alipay";
    NSString *unsign = [[params[kHttpParam_PayCallback_orderNo] stringByAppendingString:params[kHttpParam_PayCallback_payMethod]] stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    NSString *sign = [WVRGlobalUtil md5HexDigest:unsign];
    params[kHttpParam_PayCallback_sign] = sign;
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", [data contentString]);
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
        [expectation fulfill];
    };
    [api loadData];
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
