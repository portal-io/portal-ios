//
//  WVRMyOrderCell.h
//  WhaleyVR
//
//  Created by Bruce on 2017/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 我的购买cell

#import <UIKit/UIKit.h>
#import "WVRMyOrderItemModel.h"


@interface WVRMyOrderCell : UICollectionViewCell

@property (nonatomic, strong) WVRMyOrderItemModel *dataModel;

@property (nonatomic, assign, readonly) PurchaseProgramType type;

@end
