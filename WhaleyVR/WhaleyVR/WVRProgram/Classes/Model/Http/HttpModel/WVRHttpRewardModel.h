//
//  WVRHttpRewardModel.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 //    actid	活动ID
 //    action	活动代码
 //    actiontxt	活动名称
 //    uid	用户Uid
 //    whaleyuid	微鲸通行证Uid
 //    nickname	用户姓名
 //    status	状态
 //    goodsid	奖品ID
 //    name	奖品名称
 //    sortid	抽奖活动来源资源ID
 //    picture	奖品图片
 //    info	中奖奖品的相关信息
 //    dateline	创建时间
 //    goodstype	奖品类型 0:实物奖品 1:微鲸兑换码 2:虚拟卡
 */
@interface WVRHttpRewardModel : NSObject

@property (nonatomic) NSString * actid;
@property (nonatomic) NSString * action;
@property (nonatomic) NSString * actiontxt;
@property (nonatomic) NSString * uid;
@property (nonatomic) NSString * whaleyuid;

@property (nonatomic) NSString * status;
@property (nonatomic) NSString * nickname;
@property (nonatomic) NSString * goodsid;

@property (nonatomic) NSString * info;

@property (nonatomic) NSString * name;
@property (nonatomic) NSString * dateline;
@property (nonatomic) NSString * picture;
@property (nonatomic) NSString * goodstype;

@end
