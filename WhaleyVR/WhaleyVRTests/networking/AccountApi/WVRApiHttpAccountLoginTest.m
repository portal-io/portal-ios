//
//  WVRApiHttpAccountLoginTest.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRApiHttpLogin.h"
#import "WVRModelUserInfo.h"
#import "WVRModelErrorInfo.h"
#import <Kiwi/Kiwi.h>
#import "WVRModelUserInfoReformer.h"

@interface WVRApiHttpAccountLoginTest : XCTestCase

@end

@implementation WVRApiHttpAccountLoginTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWVRApiHttpAccountLogin {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRApiHttpLogin *api = [[WVRApiHttpLogin alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kWVRAPIParamsProgram_account_login_username] = @"13817425147";
    params[kWVRAPIParamsProgram_account_password] = @"whaley123";
    params[kWVRAPIParamsProgram_account_from] = @"whaleyVR";
    api.bodyParams = params;
    api.successedBlock = ^(WVRModelUserInfo *data) {
        NSLog(@"%@", data);
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRModelErrorInfo *data) {
        NSLog(@"Request Failed");
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

SPEC_BEGIN(LoginSpec)
describe(@"LoginHttpApi", ^{
    context(@"when username is 13817425147 and password is whaley123", ^{
        __block BOOL success = NO;
        __block NSError *error = nil;
        
        it(@"should login successfully", ^{
            WVRApiHttpLogin *api = [[WVRApiHttpLogin alloc] init];
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
            params[kWVRAPIParamsProgram_account_login_username] = @"13817425147";
            params[kWVRAPIParamsProgram_account_password] = @"whaley123";
            params[kWVRAPIParamsProgram_account_from] = @"whaleyVR";
            api.bodyParams = params;
            [api.executionSignal subscribeNext:^(id  _Nullable x) {
                NSLog(@"---Response--- %@", x);
                WVRModelUserInfo *modelUserInfo = [api fetchDataWithReformer:[[WVRModelUserInfoReformer alloc] init]];
                NSLog(@"---Reformer Model--- %@", modelUserInfo);
            }];
            RACSignal *netResult = [api.requestCmd execute:nil];
            // for unti test
            [netResult asynchronousFirstOrDefault:nil success:&success error:&error];
        });
    });
});
SPEC_END
