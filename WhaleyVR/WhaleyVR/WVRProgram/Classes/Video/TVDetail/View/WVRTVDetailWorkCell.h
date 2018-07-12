//
//  WVRLiveCalendarCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRTVItemModel.h"

@interface WVRTVDetailWorkCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRTVItemModel* itemModel;
@property (nonatomic) BOOL selected;
@property (nonatomic, copy) void(^didSelectBlock)(void);

@end


@interface WVRTVDetailWorkCell : SQBaseCollectionViewCell

@end
