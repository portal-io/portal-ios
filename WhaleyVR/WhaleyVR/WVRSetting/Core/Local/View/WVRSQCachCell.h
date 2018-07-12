//
//  WVRSQCachCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "WVRVideoModel.h"
#import "WVRSQDownView.h"
#import "SQDownload.h"

@interface WVRSQCachCellInfo : SQTableViewCellInfo

@property (nonatomic) SQDownload * download;
@property (nonatomic) BOOL hidenDownV;

@property (nonatomic) BOOL shouldReDown;
@property (nonatomic) WVRVideoModel * videoModel;
@property (nonatomic) WVRSQDownViewStatus downStatus;
@property (nonatomic) BOOL isStart;
@property (copy) void(^updateProgressBlock)(float progress);
@property (copy) void(^pauseBlock)(void);
@property (copy) void(^prepareBlock)(void);
@property (copy) void(^restartBlock)(void);
@property (copy) void(^updateDownStatusBlock)(WVRSQDownViewStatus downStatus);

@end
@interface WVRSQCachCell : SQBaseTableViewCell

@end
