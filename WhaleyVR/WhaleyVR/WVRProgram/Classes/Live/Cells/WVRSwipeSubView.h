//
//  WVRSwipeSubView.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/7.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVRSwipeSubView;

@protocol WVRSwipeSubViewDelegate <NSObject>

-(void)didSelectItem:(WVRSwipeSubView*)view;

@end
@interface WVRSwipeSubViewInfo : NSObject
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * imageStr;
@property (nonatomic) NSString * derscStr;
@end
@interface WVRSwipeSubView : UIView
@property (nonatomic,weak) id<WVRSwipeSubViewDelegate> delegate;
-(void)fillData:(WVRSwipeSubViewInfo*)info;

-(void)updateLayFrame;
@end
