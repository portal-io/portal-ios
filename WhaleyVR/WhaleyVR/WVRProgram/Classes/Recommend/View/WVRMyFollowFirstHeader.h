//
//  WVRMyFollowFirstHeader.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRAttentionModel.h"
#import "WVRMyFollowHeaderCell.h"

@protocol WVRMyFollowFirstHeaderDelegate <NSObject>

- (void)headerDidSelectItemAtIndex:(NSInteger)index;

@end


@interface WVRMyFollowFirstHeader : UICollectionReusableView

@property (nonatomic, weak) id<WVRMyFollowFirstHeaderDelegate> realDelegate;

@property (nonatomic , strong) NSArray<WVRAttentionCpList *> * dataArray;

@end
