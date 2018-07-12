//
//  WVRGiftAnimationPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftAnimationPresenter.h"
#import "WVRGiftAnimalView.h"
#import "WVRShowGiftStrategy.h"
#import "WVRReceiveGiftModel.h"
#import "WVRGiftAnimalViewCellViewModel.h"

@interface WVRGiftAnimationPresenter()

@property (nonatomic, strong) WVRGiftAnimalViewModel * gGiftAnimalViewModel;
@property (nonatomic, weak) WVRGiftAnimalView * gGiftAnimalView;
@property (nonatomic, strong) WVRShowGiftStrategy * gShowGiftStrategy;

@end


@implementation WVRGiftAnimationPresenter

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self gShowGiftStrategy];//初始化礼物动画strategy
        [self installRAC];
    }
    return self;
}

-(instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super initWithParams:params attchView:view];
    if (self) {
        [self gShowGiftStrategy];//初始化礼物动画strategy
        [self installRAC];
    }
    return self;
}

-(WVRShowGiftStrategy *)gShowGiftStrategy
{
    if (!_gShowGiftStrategy) {
        _gShowGiftStrategy = [[WVRShowGiftStrategy alloc] init];
        _gShowGiftStrategy.gAnimalViewModel = self.gGiftAnimalViewModel;
    }
    return _gShowGiftStrategy;
}

-(WVRGiftAnimalView *)gGiftAnimalView
{
    if (!_gGiftAnimalView) {
        _gGiftAnimalView = (WVRGiftAnimalView*)VIEW_WITH_NIB(@"WVRGiftAnimalView");
        [_gGiftAnimalView bindViewModel:self.gGiftAnimalViewModel];
    }
    return _gGiftAnimalView;
}

-(WVRGiftAnimalViewModel *)gGiftAnimalViewModel
{
    if (!_gGiftAnimalViewModel) {
        _gGiftAnimalViewModel = [[WVRGiftAnimalViewModel alloc] init];
    }
    return _gGiftAnimalViewModel;
}

-(UIView*)bindContainerView:(UIView *)view
{
    [view addSubview:self.gGiftAnimalView];
    [self.gGiftAnimalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.width.mas_equalTo(200.f);
        make.height.mas_equalTo(104.f);
        make.centerY.equalTo(view);
    }];
    return self.gGiftAnimalView;
}

-(void)installRAC
{
    RAC(self.gShowGiftStrategy, isPortrait) = RACObserve(self, isPortrait);
}

-(void)receiveGift:(WVRReceiveGiftModel*)receiveGiftModel
{
    if (!receiveGiftModel) {
        return;
    }
    WVRGiftAnimalViewCellViewModel * giftCellModel = [[WVRGiftAnimalViewCellViewModel alloc] init];
    giftCellModel.userId = receiveGiftModel.uid;
    giftCellModel.userIcon = receiveGiftModel.userHeadUrl;//@"http://test-image.tvmore.com.cn/image/get-image/10000004/15113472484166326869.jpg/zoom/692/432";
    giftCellModel.userName = receiveGiftModel.nickName;//@"luna";
    giftCellModel.giftIcon = receiveGiftModel.giftIcon;//@"http://test-image.tvmore.com.cn/image/get-image/10000004/15117681122481128955.jpg/zoom/443/260";
    giftCellModel.giftName = receiveGiftModel.giftName;//@"飞机";
//    self.gGiftAnimalViewModel.gAnimalCellModel = giftCellModel;
}

@end
