//
//  WVRDetailTagView.h
//  VRManager
//
//  Created by Snailvr on 16/6/17.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 视频详情页面的标签

#import <UIKit/UIKit.h>
#import "WVRVideoDetailVCModel.h"

typedef NS_ENUM(NSInteger, WVRDetailTagType) {
    detailTagTypeDirector = 1,                  
    detailTagTypeForm,
    detailTagTypeActor,
    detailTagTypeTag
};

@interface WVRDetailTagView : UIView

- (instancetype)initWithModel:(WVRVideoDetailVCModel *)model;

- (void)fillInfoWithModel:(WVRVideoDetailVCModel *)model;

@end
