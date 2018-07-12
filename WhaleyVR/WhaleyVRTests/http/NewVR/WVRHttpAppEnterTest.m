//
//  WVRHttpStatisticTest.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/27.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpAppEnter.h"
#import <AdSupport/AdSupport.h>
#import "WVRGlobalUtil.h"
#import "NSString +AES256.h"
#import "WVRAppModel.h"
@interface WVRHttpAppEnterTest : XCTestCase

@end

@implementation WVRHttpAppEnterTest

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
    
    WVRHttpAppEnter * cmd = [[WVRHttpAppEnter alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    // idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    idfa = @"9AE77E50-E8A1-47EE-B0DE-A1090796B99E";
    // ip
        NSString *ip = [WVRAppModel sharedInstance].ipAdress;
//        NSString *ip = @"";
    //time
    NSString *timeString = [WVRGlobalUtil getTimeStr];
//    timeString = @"1479814055076";
    // random
    NSString *random = [WVRGlobalUtil getRandomNumber32];
//    random = @"98498535702515573026212686126291";
    // platform
    NSString *platformType = @"ios";
    // version
    NSString *version = [WVRGlobalUtil getAppVersion];
    NSString *strForMd5 = [idfa stringByAppendingString:ip];
    strForMd5 = [strForMd5 stringByAppendingString:timeString];
    strForMd5 = [strForMd5 stringByAppendingString:random];
    strForMd5 = [strForMd5 stringByAppendingString:platformType];
    strForMd5 = [strForMd5 stringByAppendingString:version];
    NSLog(@"md5 msg: %@",strForMd5);
    NSString *md5Result = [WVRGlobalUtil md5HexDigest:strForMd5];
    NSLog(@"md5 msg r: %@",md5Result);
    
    NSString *strForAes = [[NSString alloc]init];
    strForAes = [strForAes stringByAppendingString:idfa];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:ip];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:timeString];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:random];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:platformType];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:version];
    strForAes = [strForAes stringByAppendingString:@","];
    strForAes = [strForAes stringByAppendingString:md5Result];
    NSLog(@"aes msg: %@",strForAes);
    NSString *aesResult = [strForAes aes256_encrypt:cKey];
    httpDic[kHttpParams_enter_content] = aesResult;
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpAppEnterModel * data) {
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
- (void) testRandom
{
    
    NSString *numberStr = [[NSString alloc] init];
    for(int i = 0; i < 32; i++)
    {
        NSString *number = [NSString stringWithFormat:@"%d", arc4random() % 10];
        numberStr = [numberStr stringByAppendingString:number];
    }
    NSLog(@"random str:%@", numberStr);
}

@end
