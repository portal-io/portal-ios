//
//  WVRApiHttpLoginRoomTest.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpRoomLogin.h"

@interface WVRApiHttpLoginRoomTest : XCTestCase

@end

@implementation WVRApiHttpLoginRoomTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPayCallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    WVRHttpRoomLogin *api = [[WVRHttpRoomLogin alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kWVRHttpRoomLogin_sid] = @"8fb2ecf6ce4b450c8785059d6cdbec69";
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;= ";
    NSString * str = [kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode];
    NSCharacterSet * cSet = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];//@" @#$%^&+=\\|[]{}:;\"?/<>,"] invertedSet];
    NSString * encodingString = [@"2K+4k免费直播测试" stringByAddingPercentEncodingWithAllowedCharacters:cSet
                                 ];
    params[kWVRHttpRoomLogin_title] = encodingString;
    api.bodyParams = params;
    api.successedBlock = ^(WVRNetworkingResponse *data) {
        
        [expectation fulfill];
    };
    api.failedBlock = ^(WVRNetworkingResponse *error) {
        NSLog(@"%@", [error contentString]);
        [expectation fulfill];
    };
    [api loadData];
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
