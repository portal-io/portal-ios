//
//  WVRPlayerFullLiveTopView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullLiveTopView.h"

@interface WVRPlayerFullLiveTopView ()
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLeadingCon;

@end

@implementation WVRPlayerFullLiveTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateContributionViewStatus:(BOOL)show
{
    if (show) {
        self.shareLeadingCon.constant = 10.f;
    }else{
        self.shareLeadingCon.constant = -90.f;
    }
    self.shareLeftLineV.hidden = !show;
    self.contributionListV.hidden = !show;
}

@end
