//
//  WVRHttpCollectionDelTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpCollectionDel.h"

@interface WVRHttpCollectionDelTest : XCTestCase

@end

@implementation WVRHttpCollectionDelTest

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
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    WVRHttpCollectionDel  * cmd = [WVRHttpCollectionDel new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_collectionDel_userLoginId] = [[WVRUserModel sharedInstance] accountId];
    params[kHttpParams_collectionDel_programCode] = @"0ddf04c2ab8f11ac8270b2d350536337";
    
    cmd.bodyParams = params;
    
    cmd.successedBlock = ^(WVRNewVRBaseResponse* args){
        
        [expectation fulfill];
    };
    
    cmd.failedBlock = ^(id args){
        if ([args isKindOfClass:[NSString class]]) {
            //            failBlock(args);
        }
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
