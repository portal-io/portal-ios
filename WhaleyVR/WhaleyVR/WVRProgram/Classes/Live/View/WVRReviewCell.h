//
//  WVRReviewCell.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/5.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 直播回顾cell

#import <UIKit/UIKit.h>
//#import "WVRReviewSectionModel.h"
#import "WVRSectionModel.h"

@interface WVRReviewCell : UICollectionViewCell

@property (nonatomic, strong) WVRItemModel *model;
- (void)setModel:(WVRItemModel *)model isHeader:(BOOL)isHeader;
@end
