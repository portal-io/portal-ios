//
//  WVRPublisherListHeader.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPublisherListModel.h"
#import "WVRPublisherDetailModel.h"

@protocol WVRPublisherListHeaderDelegate <NSObject>

- (void)sortBottonClickWithType:(PublisherSortType)type;

@end


@interface WVRPublisherListHeader : UICollectionReusableView

@property (nonatomic, weak) id<WVRPublisherListHeaderDelegate> realDelegate;

@property (nonatomic, weak) WVRPublisherDetailModel *dataModel;

- (void)listViewDidChangeToType:(PublisherSortType)type;

- (void)updateFansCount:(long)count;

@end
