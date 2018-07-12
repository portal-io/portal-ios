//
//  WVRPayCreateOrder.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPayStatusProtocol.h"
@class WVRPayModel, WVROrderModel;

@interface WVRPayCreateOrder : NSObject

@property (nonatomic, strong, readonly) RACSignal * successSignal;

@property (nonatomic, strong, readonly) RACSignal * failSignal;

@property (nonatomic, strong, readonly) RACSignal * isHaveOrderSignal;

@property (nonatomic, strong, readonly) RACSignal * payStatusSignal;

- (void)createOrder:(WVRPayModel *)payModel;

@end
