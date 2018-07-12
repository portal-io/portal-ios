//
//  WhaleyVRTests.m
//  WhaleyVRTests
//
//  Created by Snailvr on 16/7/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRMyOrderItemModel.h"

@interface WhaleyVRTests : XCTestCase

@end


@implementation WhaleyVRTests

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
    
    [WVRMyOrderItemModel requestForQueryProgramCharged:@"35061625f22148e9976ed82699423874" goodsType:PurchaseProgramTypeLive block:^(BOOL isCharged, NSError *error) {
        
        NSLog(@"error: %@", error);
        NSLog(@"ischarged: %d", isCharged);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

