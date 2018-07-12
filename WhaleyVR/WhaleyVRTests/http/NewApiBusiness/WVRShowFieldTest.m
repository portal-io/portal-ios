//
//  WVRShowFieldTest.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRShowFieldModel.h"

@interface WVRShowFieldTest : XCTestCase

@end

@implementation WVRShowFieldTest

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
    
//    [WVRShowFieldModel requestForShowFieldBannerList:^(id responseObj, NSError *error) {
//        
//        if (!error) {
//            NSLog(@"responseObj: %@", responseObj);
//        } else {
//            NSLog(@"error: %@", error);
//        }
//        
//        [expectation fulfill];
//    }];
    
    [WVRShowFieldModel requestForShowFieldList:^(id responseObj, NSError *error) {
        
        if (!error) {
            NSLog(@"responseObj: %@", responseObj);
        } else {
            NSLog(@"error: %@", error);
        }
        
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
