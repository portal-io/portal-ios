//
//  WVRTVDetailView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVDetailView.h"
#import "WVRHalfScreenPlayView.h"
#import "WVRTVDetailCollectionView.h"
//#import "WVRVideoDetailBottomView.h"
#import "WVRDetailBottomVTool.h"
#import "WVRProgramBIModel.h"

#import "WVRTVDetailBaseController.h"

@interface WVRTVDetailView ()<WVRVideoDBottomViewDelegate,WVRTVDetailCVDelegate>

@property (nonatomic, strong) WVRTVDetailViewInfo * gVInfo;

@property (nonatomic) WVRTVDetailCollectionView * mCollectionV;

//@property (nonatomic) WVRVideoDetailBottomView * mBottomV;
@property (nonatomic, strong) WVRDetailBottomVTool * gBottomVTool;

@end


@implementation WVRTVDetailView

+ (instancetype)createWithInfo:(WVRTVDetailViewInfo *)vInfo
{
    WVRTVDetailView * pageV = [[WVRTVDetailView alloc] initWithFrame:vInfo.frame withVInfo:vInfo];
    return pageV;
}

- (instancetype)initWithFrame:(CGRect)frame withVInfo:(WVRTVDetailViewInfo *)vInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gVInfo = vInfo;
        WVRHalfScreenPlayViewInfo * halfVInfo = [WVRHalfScreenPlayViewInfo new];
        halfVInfo.frame = CGRectMake(0, 0, self.width, self.width * 11 / 18.f);
        WVRHalfScreenPlayView * halfPlayV = [WVRHalfScreenPlayView createWithInfo:halfVInfo];
        halfPlayV.backgroundColor = [UIColor blackColor];
        [self addSubview:halfPlayV];
        _halfScreenPlayView = halfPlayV;
        
//        WVRVideoDetailBottomView * bottomV = [[WVRVideoDetailBottomView alloc] init];
//
//        [bottomV updateDownBtnStatus:WVRVideoDBottomVDownStatusNeedCharge];
//        [bottomV updateCollectionDone:vInfo.itemModel.haveCollection];
//        bottomV.delegate = self;
//        self.mBottomV = bottomV;
        
        [self addSubview:self.gBottomVTool.mBottomView];
        
        WVRTVDetailCollectionViewInfo * collectionVInfo = [WVRTVDetailCollectionViewInfo new];
        collectionVInfo.frame = CGRectMake(0, halfPlayV.height, self.width, self.height-halfPlayV.height-self.gBottomVTool.mBottomView.height);
        collectionVInfo.itemModel = vInfo.itemModel;
        WVRTVDetailCollectionView * collectionV = [WVRTVDetailCollectionView createWithInfo:collectionVInfo];
        collectionV.selectDelegate = self;
        collectionV.backgroundColor = [UIColor whiteColor];
        self.mCollectionV = collectionV;
        [self addSubview:collectionV];
        
        [self bringSubviewToFront:halfPlayV];
    }
    return self;
}

- (WVRDetailBottomVTool *)gBottomVTool {
    
    if (!_gBottomVTool) {
//        WVRTVItemModel * model = [[WVRTVItemModel alloc] init];
//        model.detailType = self.gVInfo.parentModel.detailType;
//        model.parentCode = self.gVInfo.parentModel.parentCode;
//        model.code = self.gVInfo.parentModel.code;
//        model.name = self.gVInfo.parentModel.name;
//        model.programType = self.gVInfo.parentModel.programType;
//        model.videoType = self.gVInfo.parentModel.videoType;
//        model.duration = self.gVInfo.parentModel.duration;
//        model.playCount = self.gVInfo.parentModel.playCount;
//        model.thubImageUrl = self.gVInfo.parentModel.thubImageUrl;
//        model.isChargeable = self.gVInfo.parentModel.isChargeable;
//        model.downloadUrl = self.gVInfo.parentModel.downloadUrl;
//        model.linkArrangeType = LINKARRANGETYPE_PROGRAM;
//        [self shieldUDLRRenderType:model];
        _gBottomVTool = [WVRDetailBottomVTool loadBottomView:self.gVInfo.parentModel parentV:self];
        [_gBottomVTool updateDownStatus:WVRVideoDownloadStatusDefault];
        _gBottomVTool.mBottomView.y = self.height - _gBottomVTool.mBottomView.height;
        _gBottomVTool.mBottomView.width = self.width;
        kWeakSelf(self);
        _gBottomVTool.shareBlock = ^(NSInteger platform) {
            if (platform != kSharePlatformLink) {
                
                WVRTVDetailBaseController *vc = (id)[weakself wvr_viewController];
                [vc trackEventForShare];
            }
        };
        _gBottomVTool.startDown = ^{
//           SQToastInKeyWindow(@"版权原因，暂不提供缓存");
        };
        _gBottomVTool.didCollection = ^{
            
            [WVRProgramBIModel trackEventForDetailWithAction:BIDetailActionTypeCollectionVR sid:weakself.gVInfo.parentModel.sid name:weakself.gVInfo.parentModel.title];
        };
        
//        [_gBottomVTool.mBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
////            make.top.equalTo(self.countLabel.mas_bottom).offset(_layoutLength);
//        }];
    }
    return _gBottomVTool;
}

- (void)onClickItemType:(WVRVideoDBottomViewType)type bottomView:(WVRVideoDetailBottomView *)view
{
    if ([self.delegate respondsToSelector:@selector(onClickItemType:bottomView:)]) {
        [self.delegate onClickItemType:type bottomView:view];
    }
}

- (void)didSelectItem:(WVRTVItemModel *)itemModel
{
    NSString * str = [NSString stringWithFormat:@"play%@", itemModel.curEpisode];
    DDLogInfo(@"%@",str);
    if ([self.delegate respondsToSelector:@selector(didSelectItemModel:)]) {
        [self.delegate didSelectItemModel:itemModel];
    }
}

//-(void)updateCollectionStatus:(BOOL)isCollection
//{
//    [self.gBottomVTool updateCollectionDone:isCollection];
//}

-(void)selectNextItem
{
    [self.mCollectionV selectNextItem];
}

-(void)reloadData
{
    [self.mCollectionV reloadData];
}

@end


@implementation WVRTVDetailViewInfo

@end
