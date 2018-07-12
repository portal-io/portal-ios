//
//  WVRPayCallbackLoadingView.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPayCallbackLoadingView.h"
#import "WVRAppContextHeader.h"

@interface WVRPayCallbackLoadingView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *statusMsgL;
@property (weak, nonatomic) IBOutlet UIView *alertV;

@end


@implementation WVRPayCallbackLoadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alertV.layer.masksToBounds = YES;
    self.alertV.layer.cornerRadius = adaptToWidth(15);
    self.statusMsgL.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bounds = self.superview.bounds;
    self.center = self.superview.center;
}

- (void)updateStatusMsg:(NSString *)msg {
    
    self.alpha = 1;
    self.hidden = NO;
    self.statusMsgL.text = msg;
}

@end
