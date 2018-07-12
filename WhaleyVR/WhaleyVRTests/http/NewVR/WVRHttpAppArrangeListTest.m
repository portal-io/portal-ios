//
//  WVRHttpAppArrangeListTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpAppArrangeList.h"

@interface WVRHttpAppArrangeListTest : XCTestCase

@end

@implementation WVRHttpAppArrangeListTest

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
    
    WVRHttpAppArrangeList * cmd = [[WVRHttpAppArrangeList alloc] init];
//    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    
//    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpAppArrangeListModel * data) {
        WVRHttpArrangeModel* model = [data.data firstObject];
        NSLog(@"model:%@",model);
        [expectation fulfill];
    };
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
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
