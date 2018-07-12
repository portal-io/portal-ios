//
//  WVRGiftAnimalViewCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRGiftAnimalViewCellViewModel : WVRViewModel

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userIcon;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * giftName;
@property (nonatomic, strong) NSString * giftIcon;

@property (nonatomic, strong) NSString * toUserName;

@property (nonatomic, assign) int giftCount;

@property (nonatomic, assign) int curGiftCount;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) RACCommand * gStartAnimationCmd;

@property (nonatomic, strong) RACCommand * gGiftCountAnimationCmd;

@property (nonatomic,copy) void(^shakeFinishedBlock)(BOOL result,NSInteger finishCount);

@property (nonatomic,copy) void(^animalFinishedBlock)(BOOL result);
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end
