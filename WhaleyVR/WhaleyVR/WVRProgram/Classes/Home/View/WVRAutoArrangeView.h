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
@interface WVRAutoArrangeViewInfo : WVRBaseViewInfo
@property (nonatomic) WVRSectionModel * sectionModel;
@end


@interface WVRAutoArrangeView : WVRBaseCollectionView

+ (instancetype)createWithInfo:(WVRAutoArrangeViewInfo *)vInfo;
- (void)requestInfo;

@end
