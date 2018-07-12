//
//  WVRLiveTopTab.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTopTab.h"

#define WIDTH_MINEBTN (50.f)
#define HEIGHT_MINEBTN (50.f)
#define Y_SUBVIEW (kStatuBarHeight)

@implementation WVRLiveTopTab

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.mSegmentV.isSamp = YES;
        [self.mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_normal"] forState:UIControlStateNormal];
        [self.mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_pre"] forState:UIControlStateHighlighted];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mSegmentV.isSamp = YES;
        [self.mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_normal"] forState:UIControlStateNormal];
        [self.mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_pre"] forState:UIControlStateHighlighted];
    }
    return self;
}

//-(SQSegmentView *)mSegmentV
//{
//    if (!_mSegmentV) {
//        _mSegmentV = [[SQSegmentView alloc] initWithFrame:[self segmentFrame]];
//        _mSegmentV.isSamp = YES;
//        _mSegmentV.backgroundColor = [UIColor clearColor];
//        [self addSubview:_mSegmentV];
//    }
//    return _mSegmentV;
//}

-(CGRect)segmentFrame
{
    return CGRectMake(WIDTH_MINEBTN, Y_SUBVIEW+fitToWidth(7.f), MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-WIDTH_MINEBTN*2, HEIGHT_MINEBTN-fitToWidth(7.f)*2);
}

-(CGRect)rightViewFrame
{
    return CGRectMake(self.mSegmentV.right, Y_SUBVIEW+fitToWidth(7.f), WIDTH_MINEBTN, HEIGHT_MINEBTN-fitToWidth(7.f)*2);
}

@end
