//
//  WVRFeedBackTest.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/25.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRLotteryModel.h"

@interface WVRFeedBackTest : XCTestCase

@end

@implementation WVRFeedBackTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    [WVRLotteryModel requestForAuthLottery:^(id responseObj, NSError *error) {
        
        if (responseObj) {
            NSLog(@"res1 = %@", responseObj);
        } else {
            NSLog(@"error = %@", error);
        }
        
        [WVRLotteryModel requestForBoxCountdownForSid:responseObj block:^(id responseObj, NSError *error) {
            
            if (responseObj) {
                NSLog(@"res = %@", responseObj);
                NSDictionary *dict = responseObj;
                NSNumber *statu = dict[@"status"];
                if (statu.intValue == 1) {
                    NSLog(@"success!!!");
                }
            } else {
                NSLog(@"error = %@", error);
            }
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
