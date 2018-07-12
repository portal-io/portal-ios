//
//  WVRDetailFooterView.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYText.h"
@class WVRDetailFooterModel;
@class WVRDetailFooterView;

@protocol WVRDetailFooterViewDelegate <NSObject>

@required
- (void)detailFooterView:(WVRDetailFooterView *)footerView didSelectItem:(NSIndexPath *)indexPath;

@end


@interface WVRDetailFooterView : UIView

@property (nonatomic, weak  ) id<WVRDetailFooterViewDelegate> realDelegate;

- (instancetype)initWithDatas:(NSArray<WVRDetailFooterModel *> *)array;

@end


@interface WVRDetailFooterCell : UICollectionViewCell

@property (nonatomic, strong) WVRDetailFooterModel *model; 

/// 图片
@property (nonatomic, weak) UIImageView *imageView;
/// 标题
@property (nonatomic, weak) YYLabel     *titleLabel;
/// 时间 播放次数
@property (nonatomic, weak) YYLabel     *timeLabel;

@end


@interface WVRDetailFooterModel : NSObject

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger playCount;
// 二选一
@property (nonatomic, copy) NSString *totalTime;        // 秒
@property (nonatomic, assign) long long duration;

@property (nonatomic, copy, readonly) NSString *timeDuration;

@end
