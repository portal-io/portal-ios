//
//  WVRLiveTopTabView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTopTabViewImpl.h"
#import "SQSegmentView.h"

#define WIDTH_MINEBTN (50.f)
#define HEIGHT_MINEBTN (50.f)
#define Y_SUBVIEW (kStatuBarHeight)

@interface WVRLiveTopTabViewImpl ()

@property (nonatomic) WVRLiveTopTabViewPresenter* vPresenter;
@property (nonatomic) SQSegmentView* mSegmentV;
@property (nonatomic) UIButton * mRightBtn;
@property (nonatomic) UIView * mbBottomLineV;

@end
@implementation WVRLiveTopTabViewImpl

+ (instancetype)loadViewWithFrame:(CGRect)frame viewPresenter:(SQBasePresenter*)viewPresenter
{
    WVRLiveTopTabViewImpl * view = [[WVRLiveTopTabViewImpl alloc] initWithFrame:frame];
    view.vPresenter = (WVRLiveTopTabViewPresenter*)viewPresenter;
    
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

-(void)loadSubViews
{
    [self mSegmentV];
    [self mRightBtn];
    self.mbBottomLineV = [[UIView alloc] initWithFrame:CGRectZero];
    self.mbBottomLineV.backgroundColor = k_Color10;
    [self addSubview:self.mbBottomLineV];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.mbBottomLineV.frame = CGRectMake(0, self.height-1.f, self.width, 1.f);
}

-(SQSegmentView *)mSegmentV
{
    if (!_mSegmentV) {
        _mSegmentV = [[SQSegmentView alloc] initWithFrame:CGRectMake(WIDTH_MINEBTN, Y_SUBVIEW+fitToWidth(7.f), SCREEN_WIDTH-WIDTH_MINEBTN*2, HEIGHT_MINEBTN-fitToWidth(7.f)*2)];
        _mSegmentV.isSamp = YES;
        _mSegmentV.backgroundColor = [UIColor clearColor];
        [self addSubview:_mSegmentV];
    }
    return _mSegmentV;
}

-(UIButton *)mRightBtn
{
    if (!_mRightBtn) {
        _mRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mSegmentV.right, Y_SUBVIEW+fitToWidth(7.f), WIDTH_MINEBTN, HEIGHT_MINEBTN-fitToWidth(7.f)*2)];
//        [_mineReserveBtn setTitle:@"我的预约" forState:UIControlStateNormal];
        [_mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_normal"] forState:UIControlStateNormal];
        [_mRightBtn setImage:[UIImage imageNamed:@"icon_live_top_tab_myreserve_pre"] forState:UIControlStateHighlighted];
        _mRightBtn.backgroundColor = [UIColor clearColor];
        [_mRightBtn addTarget:self action:@selector(onClickMineReserveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mRightBtn];
    }
    return _mRightBtn;
}

-(void)onClickMineReserveBtn
{
    if ([self.vPresenter respondsToSelector:@selector(onClickMineReserveBtn)]) {
        [(id<WVRLiveTopTabVDelegate>)self.vPresenter onClickMineReserveBtn];
    }
}

-(void)updateData:(UIScrollView*)scrollView
{
    kWeakSelf(self);
    [self.mSegmentV setItemTitles:self.vPresenter.titles andScrollView:scrollView selectedBlock:^(NSInteger index, NSInteger isRepeat) {
        NSLog(@"%ld",index);
        if([weakself.vPresenter respondsToSelector:@selector(didSelectSegmentItem:)]){
            [(id<WVRLiveTopTabVDelegate>)weakself.vPresenter didSelectSegmentItem:index];
        }
    }];
//    self.mSegmentV.sectionTitles = self.vPresenter.titles;//@[@"预告",@"推荐",@"回顾",@"秀场",@"体育",@"足球",@"电竞"];
//    self.mSegmentV.selectedSegmentIndex = 0;
//    kWeakSelf(self);
//    self.mSegmentV.indexChangeBlock = ^(NSInteger index){
//        NSLog(@"%ld",index);
//        if([weakself.vPresenter respondsToSelector:@selector(didSelectSegmentItem:)]){
//            [(id<WVRLiveTopTabVDelegate>)weakself.vPresenter didSelectSegmentItem:index];
//        }
//    };
//    self.mSegmentV.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
//    self.mSegmentV.selectedTitleTextAttributes = @{(NSForegroundColorAttributeName):k_Color1,(NSFontAttributeName):[UIFont systemFontOfSize:16]};
//    
//    self.mSegmentV.titleTextAttributes = @{(NSForegroundColorAttributeName):k_Color4,(NSFontAttributeName):[UIFont systemFontOfSize:16.f]};
//    self.mSegmentV.selectionIndicatorHeight = fitToWidth(3.f);
////    self.mSegmentV.segmentEdgeInset = UIEdgeInsetsMake(0, -27, 0, -27);
//    CGFloat leftMargin = (SCREEN_WIDTH-WIDTH_MINEBTN*2)/self.vPresenter.titles.count/2-fitToWidth(15);
//    self.mSegmentV.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, leftMargin, 0, leftMargin*2);
//    self.mSegmentV.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
}

-(void)updateSegmentSelectIndex:(NSInteger)index
{
//    self.mSegmentV.selectedSegmentIndex = index;
}

-(NSInteger)getSelectIndex
{
    return self.mSegmentV.currentItemIndex;
}
@end

