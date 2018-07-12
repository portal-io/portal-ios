//
//  WVRHttpPayCreateOrderTest.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/30.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WVRHttpPayCreatOrder.h"
#import "WVRGlobalUtil.h"
#import <SecurityFramework/Security.h>
#import "WVRHttpPayAcessToken.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@interface CreatOrder:NSObject

- (void)createOrder:(NSString *)accesseToken withExpect:(XCTestExpectation *)exception;

@end


@implementation CreatOrder

- (NSString *)md5ForPay:(NSString *)input {
    long integer = [input length];
    char charArray[integer];
    for (int i = 0; i < integer; i++) {
        char temp = [input characterAtIndex:i] & 0xff;
        charArray[i] = temp;
    }
    int integerChar = (int)sizeof(charArray);
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( &charArray, integerChar, result);
    NSString * md5Result = [[NSString alloc]init];
    for(int i = 0; i < 16; i++){
        md5Result = [md5Result stringByAppendingFormat:@"%02X", result[i]];
    }
    md5Result = [md5Result lowercaseString];
    return md5Result;
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

- (void)createOrder:(NSString *)accesseToken withExpect:(XCTestExpectation *)exception {
    
    WVRHttpPayCreatOrder *cmd = [[WVRHttpPayCreatOrder alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString* signKey = @"ad39cfe2b4622015b088bb2b7a556eb8";
    dic[@"access_token"] = accesseToken;
    
    dic[@"pay_method"] = @"upay_alipay_yun";
    dic[@"notify_url"] = @"http://www.baqqqqwwwu.com/";
    dic[@"goods_name"] = @"5枚复活币";
    dic[@"goods_no"] = @"003";
    dic[@"price"] = @"1";
    dic[@"company_id"] = @"超级网络科技";
    dic[@"app_name"] = @"超级侠客";
    NSString* strForMd5 = [dic[@"access_token"] stringByAppendingString:dic[@"pay_method"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"notify_url"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"goods_name"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"goods_no"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"price"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"company_id"]];
    strForMd5 = [strForMd5 stringByAppendingString:dic[@"app_name"]];
    strForMd5 = [strForMd5 stringByAppendingString:signKey];
    
    Security *security = [[Security alloc]init];
    NSString* strSign = [self md5ForPay:strForMd5];
    dic[@"sign"] = strSign;
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    // Create NSData object
    NSData *nsdata = [jsonString
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    NSString* dataEncrypt = [security Security_StandardEncrypt:base64Encoded withAlgid:security.payAlgid];
    NSString* stringUtf8 = [WVRGlobalUtil urlencode:dataEncrypt];
    httpDic[K_DATA] = stringUtf8;
    
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpCreateOrderModel * data) {
        NSLog(@"fail msg: %@",data);
        [exception fulfill];
    };
    
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        [exception fulfill];
    };
    [cmd execute];
}

@end


@interface WVRHttpPayCreateOrderTest:XCTestCase

@end


@implementation WVRHttpPayCreateOrderTest

- (void)testExample {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    WVRHttpPayAcessToken *cmd = [[WVRHttpPayAcessToken alloc] init];
    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
    //    httpDic[@"1"] = @"1";
    cmd.bodyParams = httpDic;
    cmd.successedBlock = ^(WVRHttpPayAccessTokenModel * data) {
        CreatOrder * order = [[CreatOrder alloc] init];
        [order createOrder:data.access_token withExpect:expectation];
        //        [expectation fulfill];
    };
    
    cmd.failedBlock = ^(NSString* errMsg){
        NSLog(@"fail msg: %@",errMsg);
        [expectation fulfill];
    };
    [cmd execute];
    
    [self waitForExpectationsWithTimeout:100.0 handler:nil];
}

- (void)setUp {
    [super setUp];
    
    //init security
    Security *sc = [Security getInstance];
    [sc Security_Init];
    [sc Security_SetUserID:@""];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testDecode {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test should succeed"];
    Security *secu = [Security getInstance];
    
    NSString *str = @"rFgKxoHZX1oSZcbOg6cd01W1MrkxFSwWAUJNKo2jBZxJ1Q0Udp1RZCcagvApCljKBVLg58jFqTubrFttnUzi96quCmxNkpRE3qs9GPfe+VNnOBnGt+UzEf2/utxiYGVdJJah2YkSNMGR8UpOUq4Jbw==_KHy2nIg+niZldVuYmApDKQ==";
    
    NSString *s2 = [secu Security_StandardDecrypt:str withAlgid:secu.payAlgid];
    NSLog(@"s2 = %@", s2);
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
