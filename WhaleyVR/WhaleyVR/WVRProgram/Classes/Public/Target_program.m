//
//  Target_program.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "Target_program.h"

#import "WVRHistoryController.h"
#import "WVRRewardController.h"
#import "WVRCollectionController.h"

#import "WVRVideoDetailVC.h"
#import "WVRLiveDetailVC.h"
#import "WVRPlayerVCLive.h"
#import "WVRProgramPackageController.h"

#import "WVRGotoNextTool.h"
#import "WVRBaseModel.h"
#import "WVRSectionModel.h"

#import "UIViewController+HUD.h"
#import "WVRPlayerVCLocal.h"

@implementation Target_program

- (UIViewController *)Action_nativeFetchHistoryViewController:(NSDictionary *)params {
    
    WVRHistoryController * vc = [[WVRHistoryController alloc] init];
    return vc;
}


- (UIViewController *)Action_nativeFetchRewardViewController:(NSDictionary *)params {
    
    WVRRewardController * vc = [[WVRRewardController alloc] init];
    return vc;
}

- (UIViewController *)Action_nativeFetchCollectionViewController:(NSDictionary *)params {
    
    WVRCollectionController * vc = [[WVRCollectionController alloc] init];
    return vc;
}

- (UIViewController *)Action_nativePlayerVCLocal:(NSDictionary *)params {
    
    WVRVideoEntityLocal *ve = [[WVRVideoEntityLocal alloc] init];
    ve.sid = params[@"sid"];
    ve.videoTitle = params[@"title"];
    ve.renderType = [params[@"renderType"] integerValue];
    ve.biEntity.totalTime = [params[@"duration"] longLongValue];
    ve.needParserURL = params[@"playURL"];
    ve.renderTypeStr = params[@"renderTypeStr"];
    ve.curDefinition = params[@"definition"];
    
    WVRPlayerVCLocal *vc = [[WVRPlayerVCLocal alloc] init];
    vc.videoEntity = ve;
    
    return vc;
}

- (UIViewController *)Action_nativeFetchVideoDetailVC:(NSDictionary *)params {
    
    NSString *linkArrangeValue = params[@"linkArrangeValue"];
    WVRVideoDetailVC *vc = [[WVRVideoDetailVC alloc] initWithSid:linkArrangeValue];
    return vc;
}

- (UIViewController *)Action_nativeFetchLiveDetailVC:(NSDictionary *)params {
    
    NSString *linkArrangeValue = params[@"linkArrangeValue"];
    WVRLiveDetailVC *vc = [[WVRLiveDetailVC alloc] initWithSid:linkArrangeValue];
    return vc;
}

- (UIViewController *)Action_nativeFetchPlayerVCLive:(NSDictionary *)params {
    
    NSString *linkArrangeValue = params[@"linkArrangeValue"];
    NSString *title = params[@"title"];
    int liveDisplayMode = [params[@"liveDisplayMode"] intValue];
    
    WVRPlayerVCLive *vc = [[WVRPlayerVCLive alloc] init];
    
    WVRVideoEntityLive *ve = [[WVRVideoEntityLive alloc] init];
    ve.sid = linkArrangeValue;
    ve.videoTitle = title;
    ve.displayMode = liveDisplayMode;
    
    ((WVRPlayerVCLive *)vc).videoEntity = ve;
    
    return vc;
}

- (UIViewController *)Action_nativeFetchProgramPackageVC:(NSDictionary *)params {
    
    NSString *linkArrangeValue = params[@"linkArrangeValue"];
    
    WVRProgramPackageController *vc = [[WVRProgramPackageController alloc] init];
    vc.createArgs = [WVRSectionModel new];
    [vc.createArgs setLinkArrangeType:LINKARRANGETYPE_CONTENT_PACKAGE];
    [vc.createArgs setLinkArrangeValue:linkArrangeValue];
     
    return vc;
}

- (void)Action_nativeGotoNextVC:(NSDictionary *)params {
    
    NSDictionary *paramDic = params[@"param"];
    if (!paramDic) { paramDic = params; }
    
    WVRBaseModel *model = [WVRBaseModel yy_modelWithDictionary:paramDic];
    UINavigationController *nav = params[@"nav"];
    
    if (!nav) {
        nav = [UIViewController getCurrentVC].navigationController;
    }
    
    if (!nav) {
        DDLogError(@"fatal error: navigationController is nil");
        return;
    }
    
    [WVRGotoNextTool gotoNextVC:model nav:nav];
}

@end
