//
//  WVRSortItemCell.h
//  WhaleyVR
//
//  Created by Snailvr on 16/7/23.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WVRSortItemCell : UICollectionViewCell

/// 标题
@property (nonatomic, weak) UILabel     *titleLabel;
/// 简介
@property (nonatomic, weak) UILabel     *detailLabel;
/// 评分
@property (nonatomic, weak) UILabel     *scoreLabel;
/// 图片
@property (nonatomic, weak) UIImageView *imageView;

/// cell样式
@property (nonatomic, assign) WVRItemCellStyle style;

@end
