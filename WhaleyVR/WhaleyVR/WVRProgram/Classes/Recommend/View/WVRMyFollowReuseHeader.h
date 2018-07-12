//
//  WVRMyFollowReuseHeader.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRMyFollowReuseHeaderDelegate <NSObject>

- (void)headerClickAtIndex:(NSInteger)section;

@end


@interface WVRMyFollowReuseHeader : UICollectionReusableView

@property (nonatomic, weak) id<WVRMyFollowReuseHeaderDelegate> realDelegate;

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long time;

@end
