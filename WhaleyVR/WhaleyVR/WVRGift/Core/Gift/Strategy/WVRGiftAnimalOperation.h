//
//  WVRGiftAnimalOperation.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVRGiftAnimalViewModel,WVRGiftAnimalViewCellViewModel;

@interface WVRGiftAnimalOperation : NSOperation

//@property (nonatomic, weak) RACCommand * gStartAnimationCmd;
@property (nonatomic, weak) WVRGiftAnimalViewModel * gAnimalViewModel;

@property (nonatomic, strong) WVRGiftAnimalViewCellViewModel * gAnimalCellViewModel;

@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@end
