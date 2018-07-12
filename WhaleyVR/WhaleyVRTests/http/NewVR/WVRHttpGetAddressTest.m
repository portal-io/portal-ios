//
//  WVRHttpGetAddress.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpGetAddress.h"
#import "WVRAddressModel.h"

@interface WVRHttpGetAddressTest : XCTestCase

@end

@implementation WVRHttpGetAddressTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    WVRHttpGetAddress  * cmd = [WVRHttpGetAddress new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_getAddress_whaleyuid] = [[WVRUserModel sharedInstance] accountId];
    
    cmd.bodyParams = params;
    
    cmd.successedBlock = ^(WVRHttpGetAddressModel* args){
        WVRAddressModel * addressModel = [[WVRAddressModel alloc] initWithHttpModel:args.member_addressdata];
//        successBlock(addressModel);
    };
    
    cmd.failedBlock = ^(id args){
        if ([args isKindOfClass:[NSString class]]) {
//            failBlock(args);
        }
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

+ (void)http_getAddressWithSuccessBlock:(void(^)(WVRAddressModel*))successBlock failBlock:(void(^)(NSString*))failBlock
{
    WVRHttpGetAddress  * cmd = [WVRHttpGetAddress new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_getAddress_whaleyuid] = [[WVRUserModel sharedInstance] accountId];
    
    cmd.bodyParams = params;
    
    cmd.successedBlock = ^(WVRHttpGetAddressModel* args){
        WVRAddressModel * addressModel = [[WVRAddressModel alloc] initWithHttpModel:args.member_addressdata];
        successBlock(addressModel);
    };
    
    cmd.failedBlock = ^(id args){
        if ([args isKindOfClass:[NSString class]]) {
            failBlock(args);
        }
    };
    [cmd execute];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
