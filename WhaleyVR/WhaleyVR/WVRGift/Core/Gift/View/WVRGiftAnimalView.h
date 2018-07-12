//
//  WVRGiftAnimalView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRViewProtocol.h"
#import "WVRViewModel.h"

@class WVRGiftAnimalViewCellViewModel;
@interface WVRGiftAnimalViewModel : WVRViewModel

@property (nonatomic, strong) WVRGiftAnimalViewCellViewModel * gFirstGiftCellViewModel;
@property (nonatomic, strong) WVRGiftAnimalViewCellViewModel * gSecGiftCellViewModel;
//@property (nonatomic, strong) WVRGiftAnimalViewCellViewModel * gAnimalCellModel;
//@property (nonatomic, strong) WVRGiftAnimalViewCellViewModel * gSecCellModel;

@end

@interface WVRGiftAnimalView : UIView<WVRViewProtocol>

@end
