//
//  WVRDetailVC+BottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRDetailBottomVTool.h"
#import "WVRUMShareView.h"
#import "WVRBIModel.h"

#import "WVRMediator+AccountActions.h"
#import "WVRCollectionViewModel.h"

@interface WVRDetailBottomVTool ()<WVRVideoDBottomViewDelegate>

@property (nonatomic, weak) UIView * mParentV;
@property (nonatomic) BOOL isCollection;
@property (nonatomic) WVRTVItemModel * mItemModel;
@property (nonatomic) WVRVideoDBottomVDownStatus downStatus;

@property (nonatomic, strong) WVRCollectionViewModel * gCollectionViewModel;

@end


@implementation WVRDetailBottomVTool

+ (WVRDetailBottomVTool *)loadBottomView:(WVRTVItemModel *)model parentV:(UIView *)parentV {
    
   return [[WVRDetailBottomVTool alloc] initWithModel:model parentV:parentV];
}

- (instancetype)initWithModel:(WVRTVItemModel *)model parentV:(UIView *)parentV {
    self = [super init];
    if (self) {
        self.mItemModel = model;
        self.mParentV = parentV;
        [self installRAC];
        if (!self.mBottomView) {
            
            float width = parentV.width;
            self.mBottomView = [[WVRVideoDetailBottomView alloc] initWithFrame:CGRectMake(0, parentV.height - HEIGHT_BOTTOMV, width, HEIGHT_BOTTOMV)];
            self.mBottomView.delegate = self;
            
            [self addLineViewForBottomView];
            
            // 嵌套到倒数第二层
            NSInteger index = parentV.subviews.count - 2;
            [parentV insertSubview:self.mBottomView atIndex:index];
            
            if (self.mItemModel.detailType == WVRVideoDetailTypeVR) {
                
                [self.mBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.mBottomView.superview);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(HEIGHT_BOTTOMV);
                }];
            }
        }
        if ([WVRUserModel sharedInstance].isLogined) {
            [self requestCollectionStatus];
        }
    }
    
    return self;
}

-(WVRCollectionViewModel *)gCollectionViewModel
{
    if (!_gCollectionViewModel) {
        _gCollectionViewModel = [[WVRCollectionViewModel alloc] init];
    }
    return _gCollectionViewModel;
}


-(void)installRAC
{
    @weakify(self);
    [[self.gCollectionViewModel gCollectionStatusCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpCollectionStatusBlock:x];
    }];
    [[self.gCollectionViewModel gCollectionStatusFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpCollectionFailBlock:x];
    }];
    
    [[self.gCollectionViewModel gCollectionDelCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpCollectionDelSuccessBlock];
    }];
    [[self.gCollectionViewModel gCollectionDelFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpCollectionFailBlock:x];
    }];
    
    [[self.gCollectionViewModel gCollectionSaveCompleteSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpCollectionSaveSuccessBlock];
    }];
    [[self.gCollectionViewModel gCollectionSaveFailSignal] subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self);
        [self httpCollectionFailBlock:x];
    }];
    
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self requestCollectionStatus];
    }];
}

- (void)collectionStatusSuccessBlock {
    
}

- (void)updateDownStatus:(WVRVideoDownloadStatus)videoStatus {
    
    BOOL isChargeable = self.mItemModel.isChargeable;
    if (isChargeable || self.mItemModel.downloadUrl.length == 0 || self.mItemModel.videoType_ != WVRModelVideoTypeVR) {
        self.downStatus = WVRVideoDBottomVDownStatusNeedCharge;
        [self.mBottomView updateDownBtnStatus:self.downStatus];
    } else {
        if (videoStatus == WVRVideoDownloadStatusDefault) {
            self.downStatus = WVRVideoDBottomVDownStatusEnable;
            [self.mBottomView updateDownBtnStatus:self.downStatus];
        } else {
            self.downStatus = WVRVideoDBottomVDownStatusDown;
            [self.mBottomView updateDownBtnStatus:self.downStatus];
        }
    }
}

- (void)requestCollectionStatus {
    
    self.gCollectionViewModel.delIds = self.mItemModel.code;
    [[self.gCollectionViewModel getCollectionStatusCmd] execute:nil];
}

- (void)httpCollectionStatusBlock:(NSNumber *)isCollection {
    
    SQHideProgressIn(self.mParentV.window);
    self.isCollection = isCollection.boolValue;
    [self.mBottomView updateCollectionDone:self.isCollection];
}

- (void)httpCollectionFailBlock:(NSString *)errMsg {
    
    SQHideProgressIn(self.mParentV.window);
    SQToastInKeyWindow(errMsg);
}

- (void)addLineViewForBottomView {
    
    float width = MIN(SCREEN_HEIGHT, SCREEN_WIDTH);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, adaptToWidth(6))];
    line.backgroundColor = k_Color10;
    
    if (_mItemModel.detailType == WVRVideoDetailTypeVR) {
        line.y = _mBottomView.height;
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, -1, width, 1)];
        line2.backgroundColor = line.backgroundColor;
        
        [_mBottomView addSubview:line2];
    } else {
        line.y = 0 - line.height;
    }
    
    [_mBottomView addSubview:line];
}

#pragma detailView - delegate

- (void)onClickItemType:(WVRVideoDBottomViewType)type bottomView:(WVRVideoDetailBottomView *)view {
    
    switch (type) {
        case WVRVideoDBottomViewTypeDown:
            [self downBtnOnClick];
            break;
        case WVRVideoDBottomViewTypeCollection:
            [self httpCollection:view];
            break;
        case WVRVideoDBottomViewTypeShare:
            [self shareOnClick];
            break;
        default:
            break;
    }
}

- (void)downBtnOnClick {
    
    if (self.downStatus == WVRVideoDBottomVDownStatusNeedCharge) {
        SQToastInKeyWindow(@"版权原因，暂不提供缓存");
    } else {
        if (self.startDown) {
            self.startDown();
        }
    }
}

- (void)didSelectItemModel:(WVRTVItemModel *)itemModel {
    
}

- (void)httpCollection:(WVRVideoDetailBottomView *)view {
    if ([WVRUserModel sharedInstance].isLogined) {
        if (self.isCollection) {
            [self httpCollectionDel:view];
        } else {
            
            [self httpCollectionSave:view];
        }
        return;
    }
    @weakify(self);
    RACCommand * cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self requestCollectionStatus];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            return nil;
        }];
    }];
    NSDictionary * params = @{@"completeCmd":cmd};
    [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:params];
}

- (void)httpCollectionSave:(WVRVideoDetailBottomView *)view {
    
    self.gCollectionViewModel.saveModel = self.mItemModel;
    [[self.gCollectionViewModel getCollectionSaveCmd] execute:nil];
}

- (void)httpCollectionSaveSuccessBlock {
    
    SQHideProgressIn(self.mParentV.window);
    SQToastInKeyWindow(@"加入播单成功");
    [self.mBottomView updateCollectionDone:YES];
    self.isCollection = YES;
    
    if (self.didCollection) {
        self.didCollection();
    }
}

- (void)httpCollectionDel:(WVRVideoDetailBottomView *)view {
    
//    kWeakSelf(self);
    self.gCollectionViewModel.delIds = self.mItemModel.code;
    
    [[self.gCollectionViewModel getCollectionDelCmd] execute:nil];
}

- (void)httpCollectionDelSuccessBlock {
    
    SQHideProgressIn(self.mParentV.window);
    SQToastInKeyWindow(@"移除播单成功");
    [self.mBottomView updateCollectionDone:NO];
    self.isCollection = NO;
}

#pragma mark - share

- (void)shareOnClick {
    // 分享功能模块
    WVRShareType type = WVRShareTypeVideoDetails;
    
    switch (self.mItemModel.linkType_) {
        case WVRLinkTypeVR:
            type = WVRShareTypeVideoDetails;
            break;
        case WVRLinkType3DMovie:
            type = WVRShareType3DMovie;
            break;
        case WVRLinkTypeMoreTV:
            type = WVRShareTypeMoreTV;
            break;
        case WVRLinkTypeMoreMovie:
            type = WVRShareTypeMoreMovie;
            break;
        case WVRLinkTypeDarma:
            type = WVRShareTypeDrama;
            break;
            
        default:
            break;
    }
    
    WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:[UIViewController getCurrentVC].view
                                       sID:self.mItemModel.parentCode
                                   iconUrl:self.mItemModel.thubImageUrl
                                     title:self.mItemModel.name
                                     intro:self.mItemModel.intrDesc
                                     mobId:nil
                                 shareType:type ];
    
    shareView.clickBlock = self.shareBlock;
}

@end
