//
//  SQNextCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface SQNextStepCellInfo : SQTableViewCellInfo

@property (nonatomic) NSString * title;
@property (copy) void(^nextSetpBlock)(void);
@property (copy) void(^updateBtnStatus)(BOOL canNextStep);

@end


@interface SQNextStepCell : SQBaseTableViewCell

@end
