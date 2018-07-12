//
//  WVRApiHttpCreateOrderTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/4/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpCreateOrder.h"
#import "WVRGlobalUtil.h"
#import "WVRUserModel.h"


@interface WVRApiHttpCreateOrderTest : XCTestCase

@end

@implementation WVRApiHttpCreateOrderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateOrder {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    WVRApiHttpCreateOrder *api = [[WVRApiHttpCreateOrder alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kHttpParam_CreateOrder_uid] = @"79260774";
    params[kHttpParam_CreateOrder_goodsNo] = @"047c7a8ea9c7444fa95590296114c3c3";
    //params[kHttpParam_CreateOrder_goodsName] = @"新码率测试-球体1920×960";//新接口已不用传名称
    params[kHttpParam_CreateOrder_goodsType] = @"recorded";
    params[kHttpParam_CreateOrder_price] = @"1";
    NSString *unSignStr = [[[[params[kHttpParam_CreateOrder_uid] stringByAppendingString:params[kHttpParam_CreateOrder_goodsNo]] stringByAppendingString:params[kHttpParam_CreateOrder_goodsType]] stringByAppendingString:params[kHttpParam_CreateOrder_price]] stringByAppendingString:[WVRUserModel CMCPURCHASE_sign_secret]];
    NSString *signStr = [WVRGlobalUtil md5HexDigest:unSignStr];
    params[kHttpParam_CreateOrder_sign] = signStr;
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
