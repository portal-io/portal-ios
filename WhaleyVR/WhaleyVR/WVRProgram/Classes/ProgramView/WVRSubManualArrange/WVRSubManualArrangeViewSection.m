//
//  WVRSubManualArrangeViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSubManualArrangeViewSection.h"
#import "WVRSectionModel.h"
#import "WVRSQArrangeMAHeader.h"
#import "WVRSQArrangeMACell.h"

#import "WVRProgramBIModel.h"

#import "WVRMediator+AccountActions.h"

#define HEIGHT_HEADER_IMAGE (211.f)
#define HEIGHT_HEADER_OTHER (89.f)

#define HEIGHT_CELL (258.f)

@interface WVRSubManualArrangeViewSection ()

@property (nonatomic, strong) WVRSectionModel * gSectionModel;

@end


@implementation WVRSubManualArrangeViewSection

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeSubManualArrange]), NSStringFromClass([WVRSubManualArrangeViewSection class]))

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self registerNibForCollectionView:self.collectionView];
    }
    return self;
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView
{
    [super registerNibForCollectionView:collectionView];
    NSArray* allCellClass = @[[WVRSQArrangeMACell class]];
    NSArray* allHeaderClass = @[[WVRSQArrangeMAHeader class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRCollectionViewSectionInfo *)getSectionInfo:(WVRSectionModel *)sectionModel
{
    self.gSectionModel = sectionModel;
    WVRSQArrangeMAHeaderInfo * headerInfo = [[WVRSQArrangeMAHeaderInfo alloc] init];
    headerInfo.cellNibName = NSStringFromClass([WVRSQArrangeMAHeader class]);
    headerInfo.sectionModel = sectionModel;
    kWeakSelf(self);
    headerInfo.gotoNextBlock = ^(id args) {
        [weakself gotoPlayList:sectionModel];
    };
    NSString *string = sectionModel.subTitle;
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12) range:NSMakeRange(0, string.length)];
    
    CGSize sizeL = [WVRComputeTool sizeOfString:attrString Size:CGSizeMake(SCREEN_WIDTH - fitToWidth(15 * 2), 2000)];
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, adaptToWidth(211 + 100) + sizeL.height);
    headerInfo.cellSize = size;
    self.headerInfo = headerInfo;
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    int num = 1;
    for (WVRItemModel *model in sectionModel.itemModels) {
        
        model.itemId = num;
        [self addCellInfoTo:cellInfos withModel:model];
        num ++;
    }
    
    self.cellDataArray = cellInfos;
    
    return self;
}

- (void)addCellInfoTo:(NSMutableArray *)cellInfos withModel:(WVRItemModel *)model {
    
    // 未知注释
//    kWeakSelf(self);
//    WVRSQArrangeMACellInfo * cellInfo = [WVRSQArrangeMACellInfo new];
//    cellInfo.cellNibName = NSStringFromClass([WVRSQArrangeMACell class]);
//    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_CELL));
//    cellInfo.gotoNextBlock = ^(id args) {
//        [weakself gotoDetail:model];
//    };
//    //cellInfo.playBlock = ^() {
//      //  model.linkArrangeType = LINKARRANGETYPE_PLAY;
//        //[weakself gotoDetail:model];
//    //};
//    cellInfo.itemModel = model;
//    [cellInfos addObject:cellInfo];
}

#pragma mark - page jump

- (void)gotoDetail:(WVRItemModel *)itemModel {
    
//    [WVRProgramBIModel trackEventForTopicWithAction:BITopicActionTypeItemPlay topicId:self.gSectionModel.linkArrangeValue topicName:self.gSectionModel.name videoSid:itemModel.linkArrangeValue videoName:itemModel.name index:itemModel.itemId isChargeable:self.gSectionModel.packModel.isChargeable isProgramSet:[self.gSectionModel.packModel isProgramSet]];
    
    [WVRTrackEventMapping trackEvent:@"topic" flag:@"video"];
    if ([itemModel.programType isEqualToString:PROGRAMTYPE_LIVE]) {
//        if ([self checkIsCharged]) {
            [self gotoNextItemVC:itemModel];
//        }
    } else {
        [self gotoNextItemVC:itemModel];
    }
}

- (BOOL)checkIsCharged {
    
    if (self.gSectionModel.packModel.isChargeable && !self.gSectionModel.haveCharged) {
        
        RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                BOOL isLogined = [input boolValue];
                if (!isLogined) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NAME_NOTF_MANUAL_ARRANGE_PROGRAMPACKAGE object:nil];
                }
                return nil;
            }];
        }];
        
        NSDictionary *dict = @{ @"cmd":cmd };
        BOOL isLogin = [[WVRMediator sharedInstance] WVRMediator_CheckAndAlertLogin:dict];
        
        if (!isLogin) {
            SQToastInKeyWindow(@"该视频尚未购买，请购买后观看");
        }
        
        return NO;
    } else {
        return YES;
    }
}

// 专题页自动连播所有视频 WVRPlayerVCTopic
- (void)gotoPlayList:(WVRSectionModel *)sectionModel {
    
//    WVRItemModel *item = sectionModel.itemModels.firstObject;
//    [WVRProgramBIModel trackEventForTopicWithAction:BITopicActionTypeListPlay topicId:self.gSectionModel.linkArrangeValue topicName:self.gSectionModel.name videoSid:item.linkArrangeValue videoName:item.name index:0 isChargeable:self.gSectionModel.packModel.isChargeable isProgramSet:[self.gSectionModel.packModel isProgramSet]];
    
    [WVRTrackEventMapping trackEvent:@"topic" flag:@"play"];
    
        NSArray * curArray = [NSArray arrayWithArray:sectionModel.itemModels];
        NSMutableArray * filterArray = [NSMutableArray new];
    
        for (WVRItemModel * cur in curArray) {
            if ([cur.programType isEqualToString:PROGRAMTYPE_LIVE]) {
                if (cur.liveStatus == WVRLiveStatusPlaying) {
                    
                    [self gotoDetail:cur];
                    return;
                } else {
//                    [filterArray addObject:cur];
                }
            } else {
                [filterArray addObject:cur];
            }
        }
        if (filterArray.count == 0) {
            SQToastInKeyWindow(@"没有视频可以播放");
            return;
        }
        sectionModel.itemModels = filterArray;
        sectionModel.linkArrangeType = LINKARRANGETYPE_PLAY_TOPIC;
        [self gotoNextSectionVC:sectionModel];
//    }
}

@end
