//
//  WVRMyRedeemCell.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRUnExchangeCodeModel.h"

@protocol WVRMyRedeemCellDelegate <NSObject>

@optional
- (void)redeemCellExchangeClick:(WVRRedeemCodeListItemModel *)dataModel;

@end


@interface WVRMyRedeemCell : UITableViewCell

@property (nonatomic, weak) id<WVRMyRedeemCellDelegate> realDelegate;
@property (nonatomic, strong) WVRRedeemCodeListItemModel *dataModel;

- (void)setIsLastCell:(BOOL)isLast;

@end


@protocol WVRUnExchangeCodeHeaderDelegate <NSObject>

@optional
- (void)headerExchangeButtonClick;

@end


@interface WVRUnExchangeCodeHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<WVRUnExchangeCodeHeaderDelegate> realDelegate;

@property (nonatomic, weak) UILabel *remindLabel;

@end
