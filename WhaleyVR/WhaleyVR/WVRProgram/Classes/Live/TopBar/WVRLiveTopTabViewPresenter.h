//
//  WVRLiveTopTabViewPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBasePresenter.h"

@class WVRItemModel;

@protocol WVRLiveTopTabProtocol <NSObject>

-(void)didSelectItem:(NSInteger)index;

@end
@interface WVRLiveTopTabViewPresenter : SQBasePresenter

@property (nonatomic, weak) UIViewController<WVRLiveTopTabProtocol>* controller;

@property (nonatomic) NSArray* titles;

@property (nonatomic, weak) UIScrollView * scrollView;
+ (instancetype)createPresenter:(id)createArgs;
-(UIView*)getView;
-(void)updateSegmentSelectIndex:(NSInteger)index;
-(NSInteger)getSelectIndex;
@property (nonatomic) void(^refreshSuccessBlock)(NSArray<WVRItemModel*>*);

@property (nonatomic) void(^refreshFaileBlock)(NSString* errorMsg);
@end
