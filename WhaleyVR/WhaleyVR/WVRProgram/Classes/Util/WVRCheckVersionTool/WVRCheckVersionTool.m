//
//  WVRCheckVersionTool.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCheckVersionTool.h"
#import <NSObject+YYModel.h>
#import "WVRNewVersionAlert.h"
#import "WVRLaunchFlowManager.h"

#define TAG_NEW_VERSION_ALERT (2000)

#define APP_STORE_ID (@"963637613")

#define APP_URL ([NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APP_STORE_ID])

//@"https://itunes.apple.com/lookup?id=963637613"

@implementation WVRCheckVersionTool

static id _storeModel_ = nil;
static BOOL _shouldShow_ = NO;

+ (void)checkHaveNewVersion
{
//    NSMutableURLRequest *formRequst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:APP_URL]];
    ;
    NSURL *url = [NSURL URLWithString:APP_URL];
    
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建task（该方法内部默认使用get）直接进行传递url即可
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [WVRCheckVersionTool responseBlock:data];
    }];
    [dataTask resume];
}

//954796570
+ (void)responseBlock:(NSData *)data
{
    if (!data) {
        return ;
    }
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * resultDic = [dic valueForKey:@"results"];
    NSDictionary * resultItemDic = [resultDic firstObject];
    if (!resultItemDic) {
        return;
    }
    WVRAppStoreModel * storeModel = [WVRAppStoreModel yy_modelWithDictionary:resultItemDic];
    NSString * version = storeModel.version;
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger versionNum = [version integerValue];
    NSString * curVersion = kAppVersion;
    curVersion = [curVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger curVersionNum = [curVersion integerValue];
    
//    if ([WVRUserModel sharedInstance].isTest) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [WVRCheckVersionTool showVersionUpdateView:storeModel];
//        });
//    }

    if (versionNum > curVersionNum) {
         dispatch_async(dispatch_get_main_queue(), ^{
             _storeModel_ = storeModel;
             [WVRCheckVersionTool shouldShowView];
         });
    } else {
        _storeModel_ = [[WVRAppStoreModel alloc] init];
        [WVRCheckVersionTool shouldShowView];
    }
}

//@"［新增功能］\n1.“首页”页面改版，展示更多推荐内容\n2.“频道”页面改版，增加更多视频分类\n3.新增“视频合辑”栏目，精准网罗各类视频，一次看完所有好东西\n\n［修复及优化］\n优化用户账号系统，解决短信验证码下发问题\n\n\n更多体验与\n能优化微鲸VR微信公众号：Whaley_VR\n了解微鲸品牌和微鲸应用：http://www.whaley-vr.com\n微鲸VR官方粉丝QQ群：467306966";//

+ (void)shouldShowUpdateTip {
    _shouldShow_ = YES;
    if (_storeModel_) {
        [self showVersionUpdateView:_storeModel_];
    }
}

+ (void)shouldShowView {
    if (_shouldShow_) {
        [self showVersionUpdateView:_storeModel_];
    }
}

+ (void)showVersionUpdateView:(WVRAppStoreModel *)storeModel {
    
    if (storeModel.version) {
        
        WVRNewVersionAlertInfo * vInfo = [WVRNewVersionAlertInfo new];
        vInfo.version = storeModel.version;
        double sizeD = [storeModel.fileSizeBytes doubleValue];
        CGFloat totalSizeMB = sizeD / 1024.0 / 1024.0;
        vInfo.size = [NSString stringWithFormat:@"%0.2fMB", totalSizeMB];
        vInfo.versionDesc = storeModel.releaseNotes;
        WVRNewVersionAlert * vAlert = (WVRNewVersionAlert *)VIEW_WITH_NIB(NSStringFromClass([WVRNewVersionAlert class]));
        [vAlert fillData:vInfo];
        vAlert.tag = TAG_NEW_VERSION_ALERT;
        vAlert.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [[[UIApplication sharedApplication].keyWindow viewWithTag:TAG_NEW_VERSION_ALERT] removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:vAlert];
    } else {
        
        [self shouldShowNextTip];
    }
}

+ (void)gotoAppstoreForNewVersion {
    
    NSString *storeURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/wei-jingvr-ni-devr-zhi-bo/id%@?mt=8", APP_STORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]];
    
    [self shouldShowNextTip];
}

+ (void)cancelUpdate {
    
    [self shouldShowNextTip];
}

+ (void)shouldShowNextTip {
    
    [[WVRLaunchFlowManager shareInstance] dealWithContentRecommend];
}

@end


@implementation WVRAppStoreModel

@end
