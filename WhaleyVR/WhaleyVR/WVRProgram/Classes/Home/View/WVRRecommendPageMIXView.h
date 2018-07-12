//
//  WVRRecommendPageView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseCollectionView.h"
#import "WVRBaseView.h"
#import "WVRSectionModel.h"

@interface WVRRecommendPageMIXViewInfo:WVRBaseViewInfo

@property (nonatomic) WVRSectionModel * sectionModel;

@end


@interface WVRRecommendPageMIXView : WVRBaseCollectionView

+ (instancetype)createWithInfo:(WVRRecommendPageMIXViewInfo *)vInfo;
- (void)requestInfo;
- (void)updateBannerAutoScroll:(BOOL)isAuto;

-(void)updatePlay;

@end
