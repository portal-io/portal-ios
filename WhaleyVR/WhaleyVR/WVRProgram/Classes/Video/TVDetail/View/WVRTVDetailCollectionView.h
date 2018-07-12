//
//  WVRTVDetailCollectionView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionView.h"
#import "WVRTVItemModel.h"


@protocol WVRTVDetailCVDelegate <NSObject>

- (void)didSelectItem:(WVRTVItemModel *)itemModel;

@end


@interface WVRTVDetailCollectionViewInfo : NSObject

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) CGRect frame;
@property (nonatomic) WVRTVItemModel * itemModel;

@end


@interface WVRTVDetailCollectionView : SQCollectionView

@property (nonatomic, weak) id<WVRTVDetailCVDelegate> selectDelegate;

+ (instancetype)createWithInfo:(WVRTVDetailCollectionViewInfo *)vInfo;

-(void)selectNextItem;
@end


@interface WVRTVDetailCollectionLayout : UICollectionViewFlowLayout

@end
