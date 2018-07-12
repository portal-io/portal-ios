//
//  WVRLiveRecommendBannerPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecommendBannerPresenter.h"
#import "WVRSectionModel.h"
#import "WVRGotoNextTool.h"
#import "WVRLiveRecBannerView.h"
#import "WVRLiveRecBannerItemView.h"
#import "WVRSmallPlayerPresenter.h"
#import <LuaParser/LPParser.h>

#define MARGIN_BANNER_ITEM (28.f)

@interface WVRLiveRecommendBannerPresenter ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>

@property (nonatomic) UIScrollView * mBottomSV;
@property (nonatomic) WVRLiveRecBannerView * mBannerV;
@property (nonatomic) WVRSmallPlayerPresenter * curPlayerP;
@property (nonatomic, assign) NSInteger gCurIndex;

@end
@implementation WVRLiveRecommendBannerPresenter
+ (instancetype)createPresenter:(id)createArgs
{
    WVRLiveRecommendBannerPresenter * presenter = [[WVRLiveRecommendBannerPresenter alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:presenter selector:@selector(refreshCurIndexPlayer:) name:NAME_NOTF_LIVE_TAB_RELOAD_PLAYER object:nil];
    [presenter loadViews];
    return presenter;
}

-(void)loadViews
{
    [self setupUI];
}

- (void)setupUI {
    
    
    WVRLiveRecBannerView *pageFlowView = [[WVRLiveRecBannerView alloc] initWithFrame:CGRectZero];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.minimumPageScale = 0.984;//0.9739;
    pageFlowView.minimumPageScale_Hor = 1;//0.92;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    
    //提前告诉有多少页
    //    pageFlowView.orginPageCount = self.imageArray.count;
    
    pageFlowView.isOpenAutoScroll = YES;
    self.mBannerV = pageFlowView;
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [bottomScrollView addSubview:pageFlowView];
    
    self.mBottomSV = bottomScrollView;
}

-(void)setFrameForView:(CGRect)frame
{
    self.mBottomSV.frame = frame;
//    CGFloat width = frame.size.width;
    self.mBannerV.frame = frame;//CGRectMake(0, 8, width, (width - 84) * 9 / 16 + 24);
}

-(void)initPlayerP
{
    if (!self.curPlayerP) {
        self.curPlayerP = [WVRSmallPlayerPresenter shareInstance];
    }
}

-(UIView *)getView
{
    return self.mBannerV;
}

-(void)fetchData
{
    [self requestInfo];
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WVRLiveRecBannerView *)flowView {
    CGFloat width = flowView.width;
    return CGSizeMake( width - MARGIN_BANNER_ITEM, flowView.height);//CGSizeMake(width - fitToWidth(36.f), flowView.height);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    WVRItemModel * itemModel = self.itemModels[subIndex];
    [WVRGotoNextTool gotoNextVC:itemModel nav:[UIViewController getCurrentVC].navigationController];
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WVRLiveRecBannerView *)flowView {
    
    return [self itemModels].count;
    
}

- (UIView *)flowView:(WVRLiveRecBannerView *)flowView cellForPageAtIndex:(NSInteger)index{
    CGFloat width = flowView.width;
    WVRLiveRecBannerItemView *bannerView = (WVRLiveRecBannerItemView *)[flowView dequeueReusableCell];
    if (!bannerView) {
//        bannerView = [[WVRLiveRecBannerItemView alloc] initWithFrame:CGRectMake(0, 0, width - 70, (width - 70) * 9 / 16)];
        bannerView = (WVRLiveRecBannerItemView*)VIEW_WITH_NIB(NSStringFromClass([WVRLiveRecBannerItemView class]));
        bannerView.frame =CGRectMake(0, 0, width - MARGIN_BANNER_ITEM, flowView.height);// CGRectMake(0, 0, width-fitToWidth(38.f), flowView.height);
        bannerView.tag = index;
        
    }
    //在这里下载网络图片
    WVRItemModel * itemModel = self.itemModels[index];
      [bannerView.mainImageView wvr_setImageWithURL:[NSURL URLWithString:itemModel.thubImageUrl] placeholderImage:HOLDER_IMAGE];
    bannerView.titleL.text = itemModel.name;
    bannerView.subTitleL.text = itemModel.subTitle;
    if (itemModel.linkType_ == WVRLinkTypeLive) {
        if (itemModel.liveStatus == WVRLiveStatusPlaying) {
            NSString* playCountStr = [WVRComputeTool numberToString:[itemModel.playCount integerValue]];
            NSString * playingIntStr = [NSString stringWithFormat:@"%@人正在观看 立即前往>",playCountStr];
            bannerView.subTitleL.text = playingIntStr;    
        }
    }
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WVRLiveRecBannerView *)flowView {
    
    self.gCurIndex = pageNumber;
    NSLog(@"ViewController 滚动到了第%ld页",(long)pageNumber);
    WVRLiveRecBannerItemView *itemView = (WVRLiveRecBannerItemView *)[flowView cells][pageNumber];
    WVRItemModel * itemModel = self.itemModels[pageNumber];
    [self.curPlayerP responseCurPage:pageNumber itemModel:itemModel contentView:itemView.mainImageView];
}

-(void)refreshCurIndexPlayer:(NSNotification*)nof
{
//    if (nof.object == self) {
        WVRLiveRecBannerItemView *itemView = (WVRLiveRecBannerItemView *)[self.mBannerV cells][self.gCurIndex];
        WVRItemModel * itemModel = self.itemModels[self.gCurIndex];
        [self.curPlayerP responseCurPage:self.gCurIndex itemModel:itemModel contentView:itemView.mainImageView];
//    }else{
//        NSLog(@"%@：不是当前的page",[self class]);
//    }
    
}


-(void)requestInfo
{
    self.gCurIndex = 0;
    [self initPlayerP];
    [self.mBannerV reloadData];
    WVRLiveRecBannerItemView *itemView = (WVRLiveRecBannerItemView *)[self.mBannerV cells][0];
    WVRItemModel * itemModel = self.itemModels[0];
    [self.curPlayerP responseCurPage:0 itemModel:itemModel contentView:itemView.mainImageView];
}

-(void)dealloc
{
    DDLogInfo(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部。
    [self.curPlayerP destroy];
    self.curPlayerP.contentView = nil;
    self.curPlayerP.itemModel = nil;
}
@end
