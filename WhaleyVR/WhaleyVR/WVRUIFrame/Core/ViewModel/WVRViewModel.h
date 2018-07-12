//
//  WVRViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/31.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModelProtocol.h"
#import "WVRErrorViewModel.h"

@interface WVRViewModel : NSObject<WVRViewModelProtocol>

@property (nonatomic, strong) WVRErrorViewModel *errorModel;

@end
