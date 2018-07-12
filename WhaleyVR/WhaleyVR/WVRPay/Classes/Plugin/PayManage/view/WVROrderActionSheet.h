//
//  WVROrderAlertView.h
//  SureCustomActionSheet
//
//  Created by Bruce on 2017/6/5.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPayGoodsType.h"
#import "WVROrderSheetHeaderView.h"
@class WVROrderAlertModel;

@protocol WVROrderActionSheetDelegate <NSObject>

@optional
- (void)jumpToProgramPackageVC;

@end


@interface WVROrderActionSheet : UIView

@property (nonatomic, readonly) OrderAlertType type;
@property (nonatomic, weak) id<WVROrderActionSheetDelegate> realDelegate;

/// OrderAlertType == OrderAlertTypeResultSuccess
- (instancetype)initWithSuccessType:(WVRPayModel *)model cancelBlock:(void (^)(void))cancelBlock;

- (instancetype)initWithType:(OrderAlertType)type
                     payList:(NSArray<NSNumber *> *)payList
                   dataModel:(WVRPayModel *)model
               selectedBlock:(void(^)(WVRPayPlatform tag, WVRPayGoodsType goodsType))selectedBlock
                 cancelBlock:(void(^)(void))cancelBlock;

- (void)showWithAnimate;
- (void)dismiss:(void(^)(void))completeBlock;

@end


@interface WVROrderAlertModel : NSObject

@property (nonatomic, assign) WVRPayPlatform orderTag;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *imgName;

@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName tag:(WVRPayPlatform)tag;

@end


@interface WVROrderActionSheetCell : UITableViewCell

@property (nonatomic, readonly) WVRPayPlatform orderTag;

- (void)setTitle:(NSString *)title icon:(UIImage *)icon tag:(WVRPayPlatform)tag;

@end
