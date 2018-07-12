//
//  WVRHomePageCollectionView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHomePageCollectionView.h"
#import "WVRBaseEmptyView.h"

@interface WVRHomePageCollectionView ()

@property (nonatomic, strong) WVRBaseEmptyView * gEmptyView;

@end


@implementation WVRHomePageCollectionView

- (void)updateWithSectionIndex:(NSInteger)sectionIndex {
    
    [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndex, 1)]];
}

- (void)fillData:(id )args {
    
    
}

- (void)dealloc {
    
    DebugLog(@"");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gEmptyView.frame = self.bounds;
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate andDataSource:(id<UICollectionViewDataSource>)dataSource {
    
    self.delegate = delegate;
    self.dataSource = dataSource;
}

- (void)reloadData {
    
    [super reloadData];
    
}

- (WVRBaseEmptyView *)gEmptyView {
    
    if (!_gEmptyView) {
        _gEmptyView = [[WVRBaseEmptyView alloc] initWithFrame:CGRectZero];
        [self addSubview:_gEmptyView];
    }
    return _gEmptyView;
}

- (UIView<WVREmptyViewProtocol> *)getEmptyView {
    
    return self.getEmptyView;
}

#pragma mark - WVREmptyView

- (void)showLoadingWithText:(NSString *)text {
    
    kWeakSelf(self);
    SQShowProgressIn(weakself);
}

- (void)hidenLoading {
    
    kWeakSelf(self);
    SQHideProgressIn(weakself);
}

- (void)showNetErrorVWithreloadBlock:(void (^)(void))reloadBlock {
    
    [self bringSubviewToFront:self.gEmptyView];
    [self.gEmptyView showNetErrorVWithreloadBlock:reloadBlock];
}

- (void)showNullViewWithTitle:(NSString *)title icon:(NSString *)icon  withreloadBlock:(void(^)(void))reloadBlock{
    
    [self bringSubviewToFront:self.gEmptyView];
    [self.gEmptyView showNullViewWithTitle:title icon:icon withreloadBlock:reloadBlock];
}

- (void)clear {
    
    self.gEmptyView.hidden = YES;
}

#pragma mark - WVRBaseViewCProtocol

-(void)requestInfo
{
    NSAssert(YES, @"must over requestInfo");
}

-(void)detailLoadFail:(id)args
{
    @weakify(self);
    if ([WVRReachabilityModel isNetWorkOK]) {
        [self showNullViewWithTitle:nil icon:nil withreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }else{
        [self showNetErrorVWithreloadBlock:^{
            @strongify(self);
            [self requestInfo];
        }];
    }
}

-(void)subHandleFail:(NSString *)toast
{
    [self showToast:toast];
}
@end
