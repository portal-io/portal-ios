//
//  WVRHttpCollectionSaveTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpCollectionSave.h"

@interface WVRHttpCollectionSaveTest : XCTestCase

@end

@implementation WVRHttpCollectionSaveTest

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
    WVRHttpCollectionSave  * cmd = [WVRHttpCollectionSave new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[kHttpParams_collectionSave_userLoginId] = [[WVRUserModel sharedInstance] accountId];
    params[kHttpParams_collectionSave_userName] = [[WVRUserModel sharedInstance] username];
    params[kHttpParams_collectionSave_programCode] = @"0ddf04c2ab8f11ac8270b2d350536337";
    params[kHttpParams_collectionSave_programName] = @"擦";
    params[kHttpParams_collectionSave_videoType] = @"2d";
    params[kHttpParams_collectionSave_programType] = @"tvprogram";
    params[kHttpParams_collectionSave_status] = @"1";
    params[kHttpParams_collectionSave_duration] = @"1000";
    params[kHttpParams_collectionSave_picUrl] = @"http://test-image.tvmore.com.cn/image/get-image/10000004/14829259923651136778.jpg/zoom/270/270";
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
