//
//  WVRSpringLotteryModel.h
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 拉取接口抽卡片

#import <Foundation/Foundation.h>
@class WVRSpringCardModel;

typedef void(^CardBlock)(WVRSpringCardModel *model, NSError *error);

@interface WVRSpringCardModel : NSObject

/// 卡片实体编码
@property (nonatomic, copy) NSString *code;

/// 是否已集齐了对应卡片组（如果用户已开过红包，也不再提示集齐）
@property (nonatomic, assign) NSInteger finished;

/// 关联卡片类型
@property (nonatomic, copy) NSString *relCardType;

/// 关联卡片类型名称
@property (nonatomic, copy) NSString *relCardName;

/// 关联卡片组名称
@property (nonatomic, copy) NSString *relCardsName;

/// 关联卡片组类型 1：现金 2：实物奖品 3：节目兑换码
@property (nonatomic, assign) NSInteger relCardGrpType;

/// 关联卡片组卡片数量
@property (nonatomic, assign) NSInteger relCardsCnt;

+ (void)requestForGetCard:(CardBlock)block;

/// 关联卡片组卡片数量转为字符串
- (NSString *)relCardsCntString;

- (NSString *)relCardGrpTypeString;

@end
