//
//  WVRHttpSearchVideoTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

//
//  WVRHttpFindStatTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpSearch.h"

@interface WVRHttpSearchVideoTest : XCTestCase

@end

@implementation WVRHttpSearchVideoTest

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
    
    WVRHttpSearch * cmd = [[WVRHttpSearch alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    httpDic[kHttpParams_search_keyWord] = @"3D标签1";
    httpDic[kHttpParams_search_type] = @"1";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpSearchMainModel * data){
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

