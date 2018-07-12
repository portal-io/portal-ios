//
//  WVRUrlParser.m
//  WhaleyVR
//
//  Created by Wang Tiger on 16/9/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HttpAgent.h"
#import "SecurityFramework/Security.h"
#import "LuaParser/LPParser.h"
#import "WLYPlayerUtils.h"

@interface WVRUrlParserTest : XCTestCase

@end

@implementation WVRUrlParserTest

- (void)setUp {
    [super setUp];
    [[HttpAgent sharedInstance] start];
    //init security
    Security *sc = [Security getInstance];
    bool isSuccessed = [sc Security_Init];
    [sc Security_SetUserID:@""];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [[HttpAgent sharedInstance] stop];
}

- (void)testUrlParser {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    NSString *currentProcessName = [[NSProcessInfo processInfo]processName];
    NSLog(currentProcessName, @"%@");
    NSString *url = @"http://vr.moguv.com/play/tvn8opxyru2d&flag=.ganalyze";
    [[LPParser sharedParser] parseUrl:url callback:^(LPParseResult *parserResult){
        NSArray<LPUrlElement *> *urlArray = [parserResult getUrlList];
        [urlArray enumerateObjectsUsingBlock:^(LPUrlElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LPUrlElement *element = [urlArray objectAtIndex:idx];
            NSString *parserUrl = [element.dullist objectAtIndex:0].url;
            NSLog(parserUrl, @"%@");
            if (parserResult.useHttpAgent) {
                //拼接地址
                NSString * spUrl = [WLYPlayerUtils getAgentUrl:parserUrl];
                NSLog(spUrl, @"%@");
            }
            [expectation fulfill];
        }
         ];
        //        [expectation fulfill];
    } targetQuality: kHD];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
