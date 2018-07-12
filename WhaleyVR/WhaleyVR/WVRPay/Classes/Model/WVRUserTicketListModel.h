//
//  WVRUserTicketListModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRUserTicketItemModel : NSObject

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *merchandiseType;
@property (nonatomic, copy) NSString *merchandiseName;
@property (nonatomic, copy) NSString *merchandiseCode;
@property (nonatomic, assign) long    updateTime;

@property (nonatomic, assign, readonly) float cellHeight;
@property (nonatomic, assign, readonly) float nameHeight;

@end


@interface WVROrderListPage : NSObject

@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int totalElements;
@property (nonatomic, assign) int numberOfElements;
@property (nonatomic, strong) NSArray<WVRUserTicketItemModel *> *content;

@end


@interface WVRUserTicketListModel : NSObject

@property (nonatomic, assign) int totalNum;
@property (nonatomic, assign) long sumAmount;
@property (nonatomic, strong) WVROrderListPage   *orderListPageCache;

@end


