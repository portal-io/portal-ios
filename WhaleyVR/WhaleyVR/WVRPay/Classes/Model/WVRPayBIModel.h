//
//  WVRPayBIModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRBIManager.h"
@class WVRPayModel;

@interface WVRPayBIModel : NSObject

/// 事件id对应哪个节目id
@property (nonatomic, copy) NSString *eventID;

/// {live,recorded，content_packge}事件类型
@property (nonatomic, copy) NSString *eventType;

+ (void)trackEventForPayWithAction:(BIPayActionType)action payModel:(WVRPayModel *)payModel fromVC:(UIViewController *)fromVC;

/// 兑换码兑换成功
//+ (void)trackEventForExchange:(WVRPayBIModel *)biModel;

/// 兑换埋点（兑换成功埋点）
+ (void)trackEventForExchangeSuccess:(NSString *)relatedCode relatedType:(NSString *)relatedType;

@end
