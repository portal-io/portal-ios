//
//  WVRFootballLiveCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@class WVRFootballModel;

@interface WVRFootballRecordCellInfo : SQCollectionViewCellInfo

@property (nonatomic, strong) WVRFootballModel* itemModel;

@end

@interface WVRFootballRecordCell : SQBaseCollectionViewCell

@end
