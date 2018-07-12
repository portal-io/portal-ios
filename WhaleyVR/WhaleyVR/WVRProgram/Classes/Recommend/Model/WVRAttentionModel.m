//
//  WVRAttentionModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的关注Model

#import "WVRAttentionModel.h"
#import "WVRWhaleyHTTPManager.h"
#import "WVRRequestClient.h"
#import "WVRRecommendViewController.h"

@implementation WVRAttentionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"latestUpdated" : [WVRAttentionLatestUpdated class], @"cpList" : [WVRAttentionCpList class], };
}


//userId  必填        用户id
//page    选填        当前页（从0开始，默认为0）
//size    选填        页大小（默认为20

// https://vrtest-api.aginomoto.com/newVR-service/appservice/cprel/myfollow?size=20&userId=39279708&page=0&systemname=android&appvercode=2017031101&appver=2.8.0.test-debug&systemver=4.4.4&appname=WhaleyVR

// 我的关注列表
+ (void)requestForMyFollowListForPage:(int)page block:(void (^)(WVRAttentionModel * model, NSError *error))block {
    
    if (![WVRUserModel sharedInstance].isisLogined) {
        WVRAttentionModel *model = [[WVRAttentionModel alloc] init];
        block(model, nil);
        return;
    }
    
    NSString *uid = [WVRUserModel sharedInstance].accountId;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAPI_SERVICE, @"cprel/myfollow"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = uid;
    params[@"size"] = @40;
    params[@"page"] = @(page);
    
    [WVRWhaleyHTTPManager GETService:urlStr withParams:params completionBlock:^(id responseObj, NSError *error) {
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        NSDictionary *resDict = dic[@"data"];
        
        if (!error && code == 200 && resDict) {
            WVRAttentionModel *model = [WVRAttentionModel yy_modelWithDictionary:resDict];
            
            block(model, nil);
        } else {
            if (error) {
                block(nil, error);
            } else {
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                block(nil, err);
            }
        }
    }];
}

// 关注/取消关注
+ (void)requestForFollow:(NSString *)cpCode status:(int)status block:(APIResponseBlock)block {
    
    NSString *uid = [WVRUserModel sharedInstance].accountId;
    if (uid.length < 1) { return; }     // 需要先登录
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@", [WVRUserModel kNewVRBaseURL], kAPI_SERVICE, @"cprel/follow"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = uid;
    params[@"cpCode"] = cpCode;
    params[@"status"] = @(status);
    
    [WVRRequestClient POSTService:urlStr withParams:params completionBlock:^(id responseObj, NSError *error) {
        NSDictionary *dic = responseObj;
        int code = [dic[@"code"] intValue];
        NSString *msg = [NSString stringWithFormat:@"%@", dic[@"msg"]];
        
        if (!error && code == 200) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAttentionStatusNoti object:nil userInfo:params];
            
            block(responseObj, nil);
        } else {
            if (error) {
                block(nil, error);
            } else {
                NSError *err = [NSError errorWithDomain:msg code:code userInfo:nil];
                block(nil, err);
            }
        }
    }];
}

@end


@implementation WVRAttentionStat

@end


@implementation WVRAttentionLatestUpdated

#pragma mark - getter

- (NSString *)sid {
    
    if (_code.length > 0) {
        return _code;
    }
    return _stat.srcCode;
}

- (NSString *)programType {
    
    if (_programType) {
        return _programType;
    }
    
    return self.stat.programType;
}

- (NSString *)videoType {
    
    if (_videoType) {
        return _videoType;
    }
    
    return self.stat.videoType;
}

#pragma mark - YYModel Setting

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

+ (NSArray *)modelPropertyBlacklist {
    
    return @[ @"sid" ];
}

@end


@implementation WVRAttentionCpList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"Id" : @"id" };
}

@end
