//
//  WVRTVDetailTitleCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTVDetailTitleCell.h"
#import "WVRScoreLabel.h"

@interface WVRTVDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *playCountL;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagLs;

@property (nonatomic) WVRTVDetailTitleCellInfo * cellInfo;
@property (nonatomic) WVRScoreLabel * mScoreL;

@end


@implementation WVRTVDetailTitleCell

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    self.cellInfo = (WVRTVDetailTitleCellInfo *)info;
    if ([self.cellInfo.itemModel.linkArrangeType isEqualToString:LINKARRANGETYPE_MOREMOVIEPROGRAM]) {
        [self loadScoreL];
    }
    
    self.nameL.text = self.cellInfo.itemModel.name;
    self.playCountL.text = [[WVRComputeTool numberToString:[self.cellInfo.itemModel.playCount integerValue]] stringByAppendingString:@"次播放"];
    NSArray * curTags = [self.cellInfo.itemModel.tags_ objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(4, self.cellInfo.itemModel.tags_.count))]];
    for (int i = 0; i < curTags.count; i ++) {
        UILabel * tagL = self.tagLs[i];
        NSString *tags = curTags[i];
        tagL.text = tags.length > 0 ? [NSString stringWithFormat:@"#%@#", curTags[i]] : @" ";
    }
}

- (void)loadScoreL {
    if (!self.mScoreL) {
        WVRScoreLabel *score = [[WVRScoreLabel alloc] initWithScore:self.cellInfo.itemModel.score];
        score.bottomX = SCREEN_WIDTH - adaptToWidth(15);
        score.centerY = self.nameL.centerY;
        
        [self addSubview:score];
        self.mScoreL = score;
    }
}

@end


@implementation WVRTVDetailTitleCellInfo

@end
