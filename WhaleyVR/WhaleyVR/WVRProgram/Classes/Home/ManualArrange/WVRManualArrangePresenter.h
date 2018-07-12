//
//  WVRManualArrangePresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"
#import "WVRManualArrangeViewCProtocol.h"
@class WVRSectionModel;

@protocol WVRPackBIDelegate <NSObject>

/// 专题、节目包、合集 BI浏览事件触发
- (void)trackEventForPackBrowse;

@end


@interface WVRManualArrangePresenter : WVRPresenter

@property (nonatomic, weak, readonly) id<WVRManualArrangeViewCProtocol> gView;

@property (nonatomic, strong, readonly) id args;

@property (nonatomic, strong) SQCollectionViewDelegate * gCollectionDelegate;
@property (nonatomic, weak) id<WVRPackBIDelegate> biDelegate;

- (NSArray *)iconStrs;
- (void)httpSuccessBlock:(WVRSectionModel *)args;

// 为BI新增两个get方法
- (NSString *)biPageId;        // linkArrangeValue
- (NSString *)biPageTitle;     // title
- (int)biIsChargeable;         // biIsChargeable
- (BOOL)isProgramSet;

@end
