//
//  WVRLiveReusableHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRLiveItemModel;
@interface WVRLiveReusableHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic) NSArray <WVRLiveItemModel*>* itemModels;

@property (nonatomic,copy) void(^livingBlock)(void);
@property (nonatomic,copy) void(^reserveCalendarBlock)(void);
@property (nonatomic,copy) void(^reviewBlock)(void);

@property (nonatomic,copy) void(^itemDidSelectBlock)(NSInteger);

@property (nonatomic) BOOL isRefresh;
@end
@interface WVRLiveReusableHeader : SQBaseCollectionReusableHeader

@end
