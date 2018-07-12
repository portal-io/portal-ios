//
//  WVRLivePlayerTopToolView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerTopView.h"
@class WVRLiveInfoAlertView;


@interface WVRPlayerLiveTopView : WVRPlayerTopView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backCons;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
- (IBAction)shareOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelWidth;
@property (weak, nonatomic) IBOutlet UIView *contributionListV;
@property (weak, nonatomic) IBOutlet UIImageView *shareLeftLineV;

//@property (nonatomic, weak) NSDictionary *ve;

/// 非秀场类直播，iconUrl直接传nil即可
//- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title watchCount:(long)count iconUrl:(NSString *)iconUrl;

//- (void)updateCount:(long)count;

//- (void)resetWithTitle:(NSString *)title curWatcherCount:(NSString *)watchCount;

@end
