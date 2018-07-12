//
//  WVRLiveInfoAlertView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRLiveInfoAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UILabel *ingTimeL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UITextView *intrL;

/// 播放器控件不自动隐藏
- (BOOL)playerUINotAutoHide;

@end
