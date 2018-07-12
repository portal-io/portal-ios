//
//  WVRHttpProgramPackageTest.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpProgramPackage.h"

@interface WVRHttpProgramPackageTest : XCTestCase

@end

@implementation WVRHttpProgramPackageTest

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
    
    WVRHttpProgramPackage *api = [[WVRHttpProgramPackage alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[kHttpParam_programPackage_code] = @"testPack";
    params[kHttpParam_programPackage_size] = @"100";
    params[kHttpParam_programPackage_page] = @"0";
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        NSLog(@"%@", data);
        //        [api loadNextPage];
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *data) {
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
