//
//  WVRApiHttpHome.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpProgramPackage.h"
#import "WVRNetworkingCMSService.h"
#import "WVRHttpProgramPackageReformer.h"

NSString * const kHttpParam_programPackage_code = @"code";
NSString * const kHttpParam_programPackage_size = @"size";
NSString * const kHttpParam_programPackage_page = @"page";

@interface WVRHttpProgramPackage () <WVRAPIManagerValidator,WVRAPIManagerCallBackDelegate>

@end


@implementation WVRHttpProgramPackage

- (void)dealloc {
    
    DDLogInfo(@"");
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
//        self.validator = self;
//        self.delegate = self;
    }
    return self;
}

#pragma mark - WVRAPIManager
- (NSString *)methodName {
    
    return @"/newVR-service/appservice/pack/findByCode";
}

- (NSString *)serviceType {
    
    return NSStringFromClass([WVRNetworkingCMSService class]);
}

- (WVRAPIManagerRequestType)requestType {
    
    return WVRAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    NSMutableDictionary *pageParams = [NSMutableDictionary dictionaryWithDictionary:params];
    pageParams[@"page"] = @(0);
    pageParams[@"size"] = @(100);
    return pageParams;
}

#pragma mark - WVRAPIManagerValidator
- (BOOL)isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}

- (BOOL)isCorrectWithCallBackData:(NSDictionary *)data {
    
    return YES;
}

#pragma mark - WVRAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(WVRNetworkingResponse *)response {
    id data = [self fetchDataWithReformer:[[WVRHttpProgramPackageReformer alloc] init]];
    self.successedBlock(data);
}

- (void)managerCallAPIDidFailed:(WVRNetworkingResponse *)response {
    self.failedBlock(response);
}

@end
