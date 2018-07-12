//
//  SQBannerView.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQBannerView : UIView

@property (nonatomic, copy) void(^onClickItemBlock)(NSInteger);
@property (nonatomic, copy) void(^updateAutoScroll)(BOOL);

- (void)updateWithData:(NSArray*)imageUrls titles:(NSArray*)titles localImageNames:(NSArray*)localImageNames;

@end
