//
//  WVRSpring2018TopicController.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/24.
//  Copyright © 2018年 Snailvr. All rights reserved.
//

#import "WVRSpring2018TopicController.h"
#import "WVRSpring2018Manager.h"

@interface WVRSpring2018TopicController ()

@end


@implementation WVRSpring2018TopicController

#pragma mark - WVRCollectionViewCProtocol

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource {
    
    self.gCollectionView.delegate = delegate;
    self.gCollectionView.dataSource = dataSource;
    
    self.gCollectionView.backgroundColor = k_Color_hex(0xffce8b);
}

#pragma mark - share
- (WVRShareType)shareType
{
    return WVRShareType2018SpringTopic;
}

- (void)shareSuccessAction:(kSharePlatform)platform {
    
    NSString *str = nil;
    switch (platform) {
        case kSharePlatformQQ:
        case kSharePlatformQzone:
            str = @"qq";
            break;
        case kSharePlatformSina:
            str = @"weibo";
            break;
        case kSharePlatformWechat:
        case kSharePlatformFriends:
            str = @"weixin";
            break;
            
        default:
            break;
    }
    [WVRSpring2018Manager reportForSharePlatform:str block:^(int count) {
//        DDLogInfo(@"新春H5分享被点击，当前可抽福卡次数：%d次", count);
    }];
}

@end
