//
//  WVRHttpHomeRecommendTest.m
//  WhaleyVR
//  主页的推荐页面
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "WVRHttpRecommendPagination.h"

@interface WVRHttpHomeRecommendTest : XCTestCase

@end

@implementation WVRHttpHomeRecommendTest

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
    
    WVRHttpRecommendPagination *cmd = [[WVRHttpRecommendPagination alloc] init];
    
    cmd.code = @"recommend";
    cmd.subCode = @"d62977a2025ed65120b0870b9e461393";
    cmd.pageNum = @"1";
    cmd.pageSize = @"3";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"v"] = @"1";
    cmd.bodyParams = params;
    cmd.successedBlock = ^(WVRHttpRecommendPaginationModel *data) {
        [expectation fulfill];
    };
    cmd.failedBlock = ^(NSString *errMsg) {
        NSLog(@"fail msg: %@", errMsg);
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
