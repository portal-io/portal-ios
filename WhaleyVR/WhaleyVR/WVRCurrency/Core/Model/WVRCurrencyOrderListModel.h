//
//  WVRCurrencyOrderListModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRCurrencyOrderListItem : NSObject

@property (nonatomic , assign) NSInteger              updateTime;
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * accountId;
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * result;
@property (nonatomic , copy) NSString              * platform;
@property (nonatomic , copy) NSString              * merchandiseType;
@property (nonatomic , copy) NSString              * merchandiseName;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , copy) NSString              * merchandiseCode;

@end


@interface WVRCurrencyOrderListPageCache : NSObject

@property (nonatomic , strong) NSArray<WVRCurrencyOrderListItem *>              * content;
@property (nonatomic , assign) NSInteger              number;
@property (nonatomic , assign) NSInteger              numberOfElements;
@property (nonatomic , assign) NSInteger              totalPages;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              total;
@property (nonatomic , assign) NSInteger              totalElements;
@property (nonatomic , assign) BOOL              first;
@property (nonatomic , assign) BOOL              last;

@end


@interface WVRCurrencyOrderListModel : NSObject

@property (nonatomic , assign) NSInteger              totalNum;
@property (nonatomic , assign) NSInteger              priceAmount;

/// 订单分页数据
@property (nonatomic , strong) WVRCurrencyOrderListPageCache    * orderListPageCache;
@property (nonatomic , assign) NSInteger              whaleyCurrencyAmount;

@end
