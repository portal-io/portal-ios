//
//  WVRPlayViewCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayViewCellProtocol.h"
#import "WVRUINotAutoShowProtocol.h"
#import "WVRPlayViewCellViewModel.h"

@interface WVRPlayViewCell : UIView<WVRPlayViewCellProtocol, WVRUINotAutoShowProtocol>

@property (nonatomic, strong) WVRPlayViewCellViewModel * gViewModel;

@end
