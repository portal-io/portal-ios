//
//  WVRManualArrangeViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 17/4/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRManualArrangeViewSection.h"
#import "WVRSectionModel.h"
#import "WVRSQArrangeMAHeader.h"
#import "WVRSQArrangeSpringHeader.h"
#import "WVRSQArrangeMACell.h"
#import "WVRProgramBIModel.h"
#import "WVRSubManualArrangeCell.h"

#import "WVRGotoNextTool.h"
#import "WVRSpring2018Manager.h"

#import "WVRMediator+AccountActions.h"

#define HEIGHT_HEADER_IMAGE (211.f)
#define HEIGHT_HEADER_OTHER (89.f)

#define HEIGHT_CELL (258.f)

#define HEIGHT_SUBMANUALL_CELL (273.f)

@interface WVRManualArrangeViewSection ()

@property (nonatomic, strong) WVRSectionModel * gSectionModel;

@end


@implementation WVRManualArrangeViewSection

@section(([NSString stringWithFormat:@"%d", (int)WVRSectionModelTypeManualArrange]), NSStringFromClass([WVRManualArrangeViewSection class]))

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
    NSArray* allCellClass = @[[WVRSQArrangeMACell class], [WVRSubManualArrangeCell class]];
    
    NSArray* allHeaderClass = @[[WVRSQArrangeMAHeader class]];
    
    for (Class class in allCellClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
    }
    
    if ([self.gSectionModel isActivity]) {
        
        allHeaderClass = @[ [WVRSQArrangeSpringHeader class] ];
    }
    
    for (Class class in allHeaderClass) {
        NSString * name = NSStringFromClass(class);
        [collectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
    }
}

- (WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel {
    
    self.gSectionModel = sectionModel;
    WVRSQArrangeMAHeaderInfo * headerInfo = [[WVRSQArrangeMAHeaderInfo alloc] init];
    if (sectionModel.isActivity) {
        
        headerInfo.cellNibName = NSStringFromClass([WVRSQArrangeSpringHeader class]);
    } else {
        
        headerInfo.cellNibName = NSStringFromClass([WVRSQArrangeMAHeader class]);
    }
    
    headerInfo.sectionModel = sectionModel;
    kWeakSelf(self);
    headerInfo.gotoNextBlock = ^(id args) {
        [weakself gotoPlayList:sectionModel];
    };
    NSString *string = sectionModel.intrDesc.length > 0 ? sectionModel.intrDesc : @"";
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 6;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:kFontFitForSize(12) range:NSMakeRange(0, string.length)];
    
    CGSize sizeL = [WVRComputeTool sizeOfString:attrString Size:CGSizeMake(SCREEN_WIDTH - fitToWidth(15 * 2), 2000)];
    
    float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGSize size = CGSizeMake(width, adaptToWidth(311) + sizeL.height);
    if ([sectionModel isActivity]) {
        size = CGSizeMake(width, fitToWidth(448));  // 309 + 106 + 1 + 32
    }
    headerInfo.cellSize = size;
    self.headerInfo = headerInfo;
    
    NSMutableArray * cellInfos = [NSMutableArray array];
    int num = 1;
    headerInfo.hidenPlayBtn = YES;
    for (WVRItemModel *model in sectionModel.itemModels) {
//        model.programType = PROGRAMTYPE_ARRANGE;
        model.itemId = num;
        if ([model.programType isEqualToString:PROGRAMTYPE_ARRANGE]) {
            headerInfo.subManualArrangeCount ++;
            [self addSubManualArrangeCellInfoTo:cellInfos withModel:model];
        } else if ([model.programType isEqualToString:PROGRAMTYPE_LIVE]) {
            [self addCellInfoTo:cellInfos withModel:model];
        } else if ([model.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
            [self addCellInfoTo:cellInfos withModel:model];
        } else {
            if (headerInfo.hidenPlayBtn) {
                headerInfo.hidenPlayBtn = NO;
            }
            [self addCellInfoTo:cellInfos withModel:model];
        }
        num ++;
    }
    
    self.cellDataArray = cellInfos;
    
    return self;
}

- (void)addCellInfoTo:(NSMutableArray *)cellInfos withModel:(WVRItemModel *)model {
    
    kWeakSelf(self);
    WVRSQArrangeMACellInfo * cellInfo = [WVRSQArrangeMACellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRSQArrangeMACell class]);
    cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_CELL));
    cellInfo.gotoNextBlock = ^(id args) {
        [weakself gotoDetail:model];
    };
    //cellInfo.playBlock = ^() {
      //  model.linkArrangeType = LINKARRANGETYPE_PLAY;
        //[weakself gotoDetail:model];
    //};
    cellInfo.args = model;
    [cellInfo convert:model];
    [cellInfos addObject:cellInfo];
}

- (void)addSubManualArrangeCellInfoTo:(NSMutableArray *)cellInfos withModel:(WVRItemModel *)model {
    
    kWeakSelf(self);
    WVRSubManualArrangeCellInfo * cellInfo = [WVRSubManualArrangeCellInfo new];
    cellInfo.cellNibName = NSStringFromClass([WVRSubManualArrangeCell class]);
//    if (cellInfos.count == 0) {
//        cellInfo.gTop = fitToWidth(24);
//        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SUBMANUALL_CELL));
//    }else{
        cellInfo.gTop = 0;
        cellInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_SUBMANUALL_CELL)-fitToWidth(24));
//    }
    
    cellInfo.gotoNextBlock = ^(id args) {
        [weakself gotoDetail:model];
    };
    cellInfo.itemModel = model;
    [cellInfos addObject:cellInfo];
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
    
    if (sectionModel.isActivity) {
        
        WVRItemModel *model = [[WVRItemModel alloc] init];
        model.linkArrangeType = LINKARRANGETYPE_H5_INNER;
        model.linkArrangeValue = [WVRSpring2018Manager shareInstance].infoModel.url;
        if ([model.linkArrangeValue containsString:@"topBarTransparent=1"]) {
            model.code = [WVRSpring2018Manager shareInstance].infoModel.code;
        }
        
        [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
        
        return;
    }
    
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
            } else if ([cur.programType isEqualToString:PROGRAMTYPE_ARRANGE]) {
                
            } else if ([cur.programType isEqualToString:PROGRAMTYPE_DRAMA]) {
                
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
