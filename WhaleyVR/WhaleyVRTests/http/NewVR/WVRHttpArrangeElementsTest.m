//
//  WVRHttpAppArrangeDetailTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface WVRHttpArrangeElementsTest : XCTestCase

@end

@implementation WVRHttpArrangeElementsTest

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
    
//    WVRHttpArrangeElements * cmd = [[WVRHttpArrangeElements alloc] init];
//    cmd.treeNodeCode= @"vr_beauty";
//    cmd.pageNum = @"1";
//    cmd.pageSize = @"3";
//    cmd.successedBlock = ^(WVRHttpArrangePageModel * data) {
//        [expectation fulfill];
//    };
//    cmd.failedBlock = ^(NSString* errMsg){
//        NSLog(@"fail msg: %@",errMsg);
//        [expectation fulfill];
//    };
//    [cmd execute];
//    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
