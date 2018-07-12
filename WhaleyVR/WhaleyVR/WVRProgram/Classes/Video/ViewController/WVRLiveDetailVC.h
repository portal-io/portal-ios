//
//  WVRLiveDetailVC.h
//  WhaleyVR
//
//  Created by Snailvr on 16/8/5.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 直播预告详情页

#import "WVRDetailVC.h"
#import "WVRLiveItemModel.h"
#import "BaseBackForResultDelegate.h"

@interface WVRLiveDetailVC : WVRDetailVC

@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic) NSString * hasOrder;

@property (nonatomic, copy) void(^reserveLiveBlock)(void(^successBlock)(void), void(^failBlock)(NSString* errStr), UIButton* btn);

- (instancetype)initWithSid:(NSString *)sid;

@end
