//
//  WVRLotteryModel.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/13.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRSnailvrHTTPManager.h"

@interface WVRLotteryModel : NSObject

+ (void)requestLotterySwitchForSid:(NSString *)sid block:(APIResponseBlock)block;

+ (void)requestForAuthLottery:(APIResponseBlock)block;

+ (void)requestForLotteryWithSid:(NSString *)sid block:(APIResponseBlock)block;

+ (void)requestForBoxCountdownForSid:(NSString *)sid block:(APIResponseBlock)block;

+ (void)requestForLotteryList:(APIResponseBlock)block;

+ (void)requestForGoodsAddress:(APIResponseBlock)block;

+ (void)requestForChageGoodsAddressWithName:(NSString *)name mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city county:(NSString *)county address:(NSString *)address block:(APIResponseBlock)block;

@end
