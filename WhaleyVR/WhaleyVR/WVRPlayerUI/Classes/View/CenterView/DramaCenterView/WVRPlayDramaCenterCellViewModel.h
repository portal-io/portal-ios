//
//  WVRPlayDramaCenterCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"
 
@interface WVRPlayDramaCenterCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, strong) NSString * leftIcon;
@property (nonatomic, strong) NSString * middleIcon;
@property (nonatomic, strong) NSString * rightIcon;


@property (nonatomic, strong) RACSignal * chooseDramaSignal;
@property (nonatomic, strong) RACCommand * goFullAnimationCmd;
@property (nonatomic, strong) RACCommand * goSmallAnimationCmd;

@property (strong, nonatomic, readonly) RACSubject * gChooseDramaSubjcet;

@end
