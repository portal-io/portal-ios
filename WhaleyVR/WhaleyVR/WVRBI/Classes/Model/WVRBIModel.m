//
//  WVRBIModel.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBIModel.h"
#import "WVRSQLiteManager.h"
#import <WVRAppDebugDefine.h>
#import <WVRAppModel.h>
#import <WVRUserModel.h>
#import <CommonCrypto/CommonDigest.h>
#import "WVRBIManager.h"

@implementation WVRBIModel

- (instancetype)init {
    self  = [super init];
    if (self) {
        // 不能忘记初始化 ！！！
        self.metadata = [[WVRBIMetadataModel alloc] init];
        self.logInfo = [[WVRBILogInfoModel alloc] init];
    }
    return self;
}

static long wvr_BI_currentDataCount = 0;

- (void)saveToSQLite {
    
    NSString *jsonStr = [self yy_modelToJSONString];
    
//    NSLog(@"BI: - \n%@\n", jsonStr);
    
    [[WVRSQLiteManager sharedManager] insertBIEvent:jsonStr];
    
    wvr_BI_currentDataCount += 1;
    
    if (wvr_BI_currentDataCount > 25) {
        [WVRBIManager uploadBIEvents];
        wvr_BI_currentDataCount = 0;
    }
}

@end


@implementation WVRBIMetadataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.sessionId = [[self class] biSessionId];
        self.userId = [WVRUserModel sharedInstance].deviceId;
        self.apkVersion = kAppVersion;
        self.apkSeries = kBuildVersion;
        self.productModel = [WVRUserModel sharedInstance].deviceModel;
        self.romVersion = [[UIDevice currentDevice] systemVersion];
        self.buildDate = kBuildVersion;
        self.isRandom = @"0";
        self.systemName = @"IOS";
        self.promotionChannel = @"AppStore";
        self.productModel = [WVRUserModel sharedInstance].deviceModel;
        if ([WVRUserModel sharedInstance].accountId.length) {
            self.accountId = [WVRUserModel sharedInstance].accountId;
        }
    }
    return self;
}


#pragma mark - private

static long k_currentLogId = 0;
static NSString *k_biSessionId = nil;

+ (NSString *)biSessionId {
    
    if (!k_biSessionId) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        k_biSessionId = [self encryptByMD5:[NSString stringWithFormat:@"%f", time]];
    }
    return k_biSessionId;
}

+ (long)currentLogId {
    
    k_currentLogId += 1;
    return k_currentLogId;
}

+ (NSString *)encryptByMD5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSString *hexStr = @"";
    for (int i = 0; i < 16; i ++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x", (result[i])]; // 16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}


@end


@implementation WVRBILogInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logId = [WVRBIMetadataModel currentLogId];
        self.happenTime = round([[NSDate date] timeIntervalSince1970] * 1000);
        self.isTest = kAppEnvironmentTest;
        self.logVersion = @"02";
//        self.networkStatus = [WVRReachabilityModel sharedInstance].netWorkStatus;
        
    }
    return self;
}

@end
