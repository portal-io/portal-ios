//
//  WVRManualArrangeShareViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualArrangeShareViewSection.h"
#import "WVRSectionModel.h"
#import "WVRSQTagHorCell.h"
#import "WVRManualAShareCell.h"
#import "WVRManualArrangeShareHeader.h"

#import "WVRUMShareView.h"

#import "WVRProgramBIModel.h"
#import "WVRSpring2018Manager.h"

@interface WVRManualArrangeShareViewSection ()

@property (nonatomic, strong) NSString * gCode;

@property (nonatomic, strong) NSString * gLinkType;

@property (nonatomic, strong) NSString * gThubImageUrl;

@property (nonatomic, strong) NSString * gName;

@property (nonatomic, strong) NSString * gIntrDesc;

@property (nonatomic, strong) WVRUMShareView* mShareView;

@end


@implementation WVRManualArrangeShareViewSection

@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeManualArrangeShare]), NSStringFromClass([WVRManualArrangeShareViewSection class]))

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView
{
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQTagHorCell class]];
    NSArray* allHeaderClass = @[];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}


- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel
{    
    NSMutableArray * cellInfos = [NSMutableArray array];
    WVRSQTagHorCellInfo * tagCellInfo = [WVRSQTagHorCellInfo new];
    tagCellInfo.cellNibName = NSStringFromClass([WVRSQTagHorCell class]);
    tagCellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(191.f));
    tagCellInfo.originDic = [self getSubTagCollectionDic:sectionModel];
    tagCellInfo.cellNibNames = [self getSubTagCollectionCellNibNames];
    tagCellInfo.headerNibNames = [self getSubTagCollectionHeaderNibNames];
    tagCellInfo.noSplitV = YES;
    [cellInfos addObject:tagCellInfo];
    self.cellDataArray = cellInfos;
    
    return self;
}

- (NSDictionary*)getSubTagCollectionDic:(WVRSectionModel*)sectionModel
{
    NSMutableDictionary * originDic = [NSMutableDictionary dictionary];
    originDic[@(0)] = [self getSubTagSectionInfo:sectionModel];
    return originDic;
}

- (NSArray*)getSubTagCollectionCellNibNames
{
    return @[NSStringFromClass([WVRManualAShareCell class])];
}

- (NSArray*)getSubTagCollectionHeaderNibNames
{
    return @[NSStringFromClass([WVRManualArrangeShareHeader class])];
}

- (SQCollectionViewSectionInfo *)getSubTagSectionInfo:(WVRSectionModel *)sectionModel
{
    self.gCode = sectionModel.linkArrangeValue;
    self.gThubImageUrl = sectionModel.thubImageUrl;
    self.gLinkType = sectionModel.linkArrangeType;
    self.gName = sectionModel.name;
    self.gIntrDesc = sectionModel.intrDesc;
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    sectionInfo.edgeInsets = UIEdgeInsetsMake(fitToWidth(0), fitToWidth(20), fitToWidth(0), fitToWidth(20));
    SQCollectionViewHeaderInfo * headerInfo = [SQCollectionViewHeaderInfo new];
    headerInfo.cellNibName = NSStringFromClass([WVRManualArrangeShareHeader class]);
    headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(91.f));
    sectionInfo.headerInfo = headerInfo;
    NSMutableArray * cellInfos = [NSMutableArray array];
    for (WVRItemModel* model in [sectionModel.itemModels objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(5, sectionModel.itemModels.count))]]) {
        
        [cellInfos addObject:[self getTagCellInfo:model]];
    }
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}

- (WVRManualAShareCellInfo *)getTagCellInfo:(WVRItemModel *)model
{
//    kWeakSelf(self);
    WVRManualAShareCellInfo * tagCellInfo = [WVRManualAShareCellInfo new];
    tagCellInfo.cellNibName = NSStringFromClass([WVRManualAShareCell class]);
    tagCellInfo.cellSize = CGSizeMake((SCREEN_WIDTH - fitToWidth(20.f) * 2)/5, fitToWidth(85.f));
    tagCellInfo.title = model.name;
    tagCellInfo.localImageStr = model.thubImageUrl;
    @weakify(self);
    tagCellInfo.gotoNextBlock = ^(WVRManualAShareCellInfo* args) {
        @strongify(self);
        [self shareNotfResponse:model.thubImageUrl];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_MANUAL_ARRANGE_SHARE object:model.thubImageUrl];
    };
    return tagCellInfo;
}


- (NSArray *)iconStrs {
    
    return [NSArray arrayWithObjects:@"share_icon_sina", @"share_icon_wechat", @"share_icon_friends", @"share_icon_qq", @"share_icon_qzone", nil];
}

- (void)shareNotfResponse:(NSString *)blockKey {
    
    void(^block)(void) = [self shareBlockDic][blockKey];
    block();
}

- (NSDictionary *)shareBlockDic {
    
    NSString * sinaK = [[self iconStrs] firstObject];
    
    NSString * wechatK = [self iconStrs][kSharePlatformQQ];
    NSString * wechatLineK = [self iconStrs][kSharePlatformWechat];
    NSString * qqK = [self iconStrs][kSharePlatformQzone];
    
    NSString * qzoneK = [[self iconStrs] lastObject];
    
    kWeakSelf(self);
    return @{sinaK:^{
        [weakself.mShareView shareToIndex:kSharePlatformSina];
    },
             wechatK:^{
                 [weakself.mShareView shareToIndex:kSharePlatformWechat];
             },
             wechatLineK:^{
                 [weakself.mShareView shareToIndex:kSharePlatformFriends];
             },
             qqK:^{
                 [weakself.mShareView shareToIndex:kSharePlatformQQ];
             },
             qzoneK:^{
                 [weakself.mShareView shareToIndex:kSharePlatformQzone];
             }
             };
}

#pragma mark - share

- (WVRUMShareView *)mShareView {
    // 分享功能模块
    
    if (!_mShareView) {
        WVRUMShareView *shareView = [WVRUMShareView shareWithContainerView:[[UIView alloc] init]
                                                                       sID:self.gCode
                                                                   iconUrl:self.gThubImageUrl
                                                                     title:self.gName
                                                                     intro:self.gIntrDesc
                                                                     mobId:nil
                                                                 shareType:[self shareType]];
        _mShareView = shareView;
        _mShareView.alpha = 0;
//        [self.view addSubview:_mShareView];
        
        kWeakSelf(self);
        _mShareView.clickBlock = ^(kSharePlatform platform) {
            if (platform != kSharePlatformLink) {
                
                [WVRProgramBIModel trackEventForShare:[weakself biModel]];
                [weakself shareSuccessAction:platform];
            }
        };
    }
    return _mShareView;
}

- (WVRProgramBIModel *)biModel {
    
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    UIViewController *currentVC = [UIViewController getCurrentVC];
    
    NSString *currentPageId = nil;
    if ([currentVC respondsToSelector:@selector(currentPageId)]) {
        currentPageId = [currentVC performSelector:@selector(currentPageId)];
    }
    model.currentPageId = currentPageId;
    
    model.biPageId = self.gCode;
    model.biPageName = self.gName;
    
    return model;
}

- (WVRShareType)shareType
{
    if ([self.gLinkType isEqualToString:LINKARRANGETYPE_CONTENT_PACKAGE]) {
        return WVRShareTypeSpecialProgramPackage;
    } else {
        return WVRShareTypeSpecialTopic;
    }
}

#pragma mark - share

- (void)shareSuccessAction:(kSharePlatform)platform {
    
    NSString *str = nil;
    switch (platform) {
        case kSharePlatformQQ:
        case kSharePlatformQzone:
            str = @"qq";
            break;
        case kSharePlatformSina:
            str = @"weibo";
            break;
        case kSharePlatformWechat:
        case kSharePlatformFriends:
            str = @"weixin";
            break;
            
        default:
            break;
    }
    [WVRSpring2018Manager reportForSharePlatform:str block:^(int count) {
        //        DDLogInfo(@"新春H5分享被点击，当前可抽福卡次数：%d次", count);
    }];
}

@end
