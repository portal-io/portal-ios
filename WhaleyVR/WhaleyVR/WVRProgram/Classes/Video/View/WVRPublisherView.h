//
//  WVRPublisherView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRPublisherView : UIView

@property (nonatomic, copy) NSString *cpCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) long fansCount;
@property (nonatomic, assign) long isFollow;

@property (nonatomic, weak) UIButton *button;

- (void)viewWillAppear;

@end
