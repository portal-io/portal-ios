//
//  WVRAddressBtnCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface WVRAddressBtnCellInfo : SQTableViewCellInfo

@property (nonatomic, copy) void(^commitBlock)(void);

@end


@interface WVRAddressBtnCell : SQBaseTableViewCell

- (void)updateBtnStatus:(BOOL)enabel;

@end
