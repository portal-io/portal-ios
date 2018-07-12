//
//  WVRGiftAnimalView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftAnimalView.h"
#import "WVRGiftAnimalViewCell.h"
#import "WVRGiftAnimalViewCellViewModel.h"

@interface WVRGiftAnimalView()

@property (nonatomic, strong) WVRGiftAnimalViewModel * gViewModel;

@property (nonatomic, weak) WVRGiftAnimalViewCell * gFirstCell;
@property (nonatomic, weak) WVRGiftAnimalViewCell * gSecCell;

@end

@implementation WVRGiftAnimalView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.gFirstCell.hidden = YES;
    self.gSecCell.hidden = YES;
    [self addSubview:self.gFirstCell];
    [self addSubview:self.gSecCell];
    [self createlayouts];
}

-(void)createlayouts
{
    [self.gFirstCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7.f);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(60.f);
        make.centerY.equalTo(self).offset(-35);
    }];
    [self.gSecCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7.f);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(60.f);
        make.centerY.equalTo(self).offset(fitToWidth(25));
    }];
}

-(WVRGiftAnimalViewCell *)gFirstCell
{
    if (!_gFirstCell) {
        _gFirstCell = (WVRGiftAnimalViewCell*)VIEW_WITH_NIB(@"WVRGiftAnimalViewCell");
    }
    return _gFirstCell;
}

-(WVRGiftAnimalViewCell *)gSecCell
{
    if (!_gSecCell) {
        _gSecCell = (WVRGiftAnimalViewCell*)VIEW_WITH_NIB(@"WVRGiftAnimalViewCell");
    }
    return _gSecCell;
}

-(void)bindViewModel:(id)viewModel
{
    if (self.gViewModel == viewModel) {
        return;
    }
    self.gViewModel = viewModel;
    [self installRAC];
}

-(void)installRAC
{
    @weakify(self);
    [RACObserve(self.gViewModel, gFirstGiftCellViewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.gFirstGiftCellViewModel) {
            [self.gFirstCell bindViewModel:self.gViewModel.gFirstGiftCellViewModel];
        }
    }];
    [RACObserve(self.gViewModel, gSecGiftCellViewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.gSecGiftCellViewModel) {
            [self.gSecCell bindViewModel:self.gViewModel.gSecGiftCellViewModel];
        }
    }];
//    self.gViewModel.gStartAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self);
//        [self startAnimation:input];
//        return [RACSignal empty];
//    }];
}

-(void)startAnimation:(WVRGiftAnimalViewCellViewModel*)viewModel
{
    if (viewModel.index == 0) {
        [self.gFirstCell bindViewModel:viewModel];
    }else{
        [self.gSecCell bindViewModel:viewModel];
    }
}


@end

@implementation WVRGiftAnimalViewModel

@end
