//
//  WVRMyOrderViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRMyOrderItemModel.h"

@interface WVRMyOrderViewModel : WVRViewModel

@property (nonatomic, strong) NSString * gPage;

@property (nonatomic, strong) WVRMyOrderListModel * gResponseModel;

@property (nonatomic, strong) WVRErrorViewModel * gErrorViewModel;

- (RACCommand *)myOrderListCmd;

@end
