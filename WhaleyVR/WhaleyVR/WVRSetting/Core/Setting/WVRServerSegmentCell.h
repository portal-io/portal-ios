//
//  WVRServerSegmentCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface WVRServerSegmentCellInfo : SQTableViewCellInfo

@property (nonatomic, copy) void(^onLineBlock)(void);
@property (nonatomic, copy) void(^onTestBlock)(void);

@end


@interface WVRServerSegmentCell : SQBaseTableViewCell

@end
