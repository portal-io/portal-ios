//
//  WVRMyFollowReuseFooter.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FollowReuseFooterType) {
    
    FollowReuseFooterTypeMore,          // 展开更多
    FollowReuseFooterTypeLess,          // 收起
};

@protocol WVRMyFollowReuseFooterDelegate <NSObject>

- (void)footerClickAtIndex:(NSInteger)section;

@end


@interface WVRMyFollowReuseFooter : UICollectionReusableView

@property (nonatomic, weak) id<WVRMyFollowReuseFooterDelegate> realDelegate;
@property (nonatomic, assign) FollowReuseFooterType type;

@end
