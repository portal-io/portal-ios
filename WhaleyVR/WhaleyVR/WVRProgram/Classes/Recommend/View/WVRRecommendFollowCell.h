//
//  WVRRecommendFollowCell.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//
// 推荐关注主列表Cell

#import <UIKit/UIKit.h>
#import "WVRRecommendFollowModel.h"

@protocol WVRRecommendFollowCellDelegate <NSObject>

/// -1表示 header或者footer
- (void)itemCellDidSelectAtIndex:(NSInteger)index withDataModel:(WVRRecommendFollowItemModel *)dataModel;

@end


@interface WVRRecommendFollowCell : UICollectionViewCell

@property (nonatomic, weak) id<WVRRecommendFollowCellDelegate> realDelegate;

@property (nonatomic, weak) WVRRecommendFollowItemModel *dataModel;

@property (nonatomic, assign, readonly) float offsetX;

- (void)stopCollectionAnimation;
- (void)setOffsetX:(float)offsetX;

// for header change fansCount
- (void)updateFansCountWithFollow:(BOOL)isFollow cpCode:(NSString *)cpCode;

@end

/********************************************/

@interface WVRRecommendFollowCellFooter : UICollectionReusableView

@property (nonatomic, weak) UIButton *moreBtn;

@end

/********************************************/

@interface WVRRecommendFollowCellHeader : UIView

@property (nonatomic, copy) NSString *cpCode;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, weak) UIButton *button;

- (void)updateFollowBtn:(BOOL)isFollow;

@end

/********************************************/

@interface WVRRecommendFollowCellIntroView : UICollectionReusableView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) long fansCount;

@end

/********************************************/

@interface WVRRecommendFollowCellItem : UICollectionViewCell

@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long playCount;

@end

/********************************************/

@interface WVRRecommendFollowHeader : UICollectionReusableView

@property (nonatomic, copy) NSString *picUrl;

@end

