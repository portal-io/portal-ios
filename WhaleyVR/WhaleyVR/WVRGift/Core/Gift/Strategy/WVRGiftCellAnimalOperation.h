//
//  WVRGiftCellAnimalOperation.h
//  WhaleyVR
//
//  Created by qbshen on 2017/12/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WVRGiftAnimalViewCellViewModel;

@interface WVRGiftCellAnimalOperation : NSOperation

@property (nonatomic, weak) WVRGiftAnimalViewCellViewModel * gAnimalCellViewModel;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@end
