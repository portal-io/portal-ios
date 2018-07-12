//
//  WVROrderSheetHeaderView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPayGoodsType.h"
#import "WVRPayModel.h"
@class WVROrderGoodsSelectLabel, WVROrderGoodsNameLabel;

typedef NS_ENUM(NSInteger, GoodsSelectType) {
    
    GoodsSelectTypeNone,
    GoodsSelectTypeSelected,
    GoodsSelectTypeAlternative,
};

@interface WVROrderSheetHeaderView : UIView

@property (nonatomic, weak, readonly) WVROrderGoodsSelectLabel *goodsLabel;

@property (nonatomic, weak, readonly) UILabel *statusLabel;

- (instancetype)initWithFrame:(CGRect)frame payModel:(WVRPayModel *)payModel type:(OrderAlertType)type canPayWithJingbi:(BOOL)canPayWithJingbi;

@property (nonatomic, assign, readonly) WVRPayGoodsType selectedType;

#pragma mark - private

- (void)selectLabelTapAction:(WVROrderGoodsSelectLabel *)label;
- (void)goPackgeDetailVC;
- (void)installCircularBeadAndImaginaryLine:(CGFloat)tagY;

@end


@interface WVROrderGoodsSelectLabel: UIView

@property (nonatomic, readonly) WVRPayGoodsType type;

@property (nonatomic, weak, readonly) WVROrderGoodsNameLabel *nameLabel;

- (instancetype)initWithFrame:(CGRect)frame price:(long)price title:(NSString *)title selectStatus:(GoodsSelectType)selectStatus type:(WVRPayGoodsType)type packageType:(WVRPackageType)packageType needHideDetail:(BOOL)needHideDetail jingbiPrice:(NSNumber *)jingbiPrice;

- (void)resetSelectStatus;

//- (void)setIsFormUnity:(BOOL)isUnity;

+ (float)miniHeight;        /** 只显示文字，不选择时的高度 */
+ (float)normalHeight;      /** 未选择时高度 */
+ (float)selectHeight;      /** 已选择时高度 */

@end


@interface WVROrderGoodsNameLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;

@end
