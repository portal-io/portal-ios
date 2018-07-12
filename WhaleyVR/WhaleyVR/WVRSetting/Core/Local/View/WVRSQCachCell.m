//
//  WVRSQCachCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQCachCell.h"


@interface WVRSQCachCell ()
@property  (nonatomic) WVRSQDownViewInfo * viewInfo;
@property (weak, nonatomic) IBOutlet WVRSQDownView *mDownView;
@property (nonatomic) WVRSQCachCellInfo* cellInfo;
@property (weak, nonatomic) IBOutlet UIImageView *thubImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;

@end
@implementation WVRSQCachCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    kWeakSelf(self);
    self.viewInfo = [WVRSQDownViewInfo new];
    self.viewInfo.startDownBlock = ^{
        
    };
    self.viewInfo.pauseDownBlock = ^{
        weakself.cellInfo.pauseBlock();
        
    };
    self.viewInfo.stopDownBlock = ^{

    };
    self.viewInfo.restartDownBlock = ^{
        weakself.cellInfo.restartBlock();
        
    };
    
    self.viewInfo.prepareDownBlock = ^{
        weakself.cellInfo.prepareBlock();

    };
    [self.mDownView updateViewWithInfo:self.viewInfo];
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.cellInfo = (WVRSQCachCellInfo*)info;
    if (self.cellInfo.hidenDownV) {
        self.mDownView.hidden = YES;
    }
    if (self.cellInfo.videoModel.localThubImage) {
        self.thubImageV.image = self.cellInfo.videoModel.localThubImage;
    }else{
        [self.thubImageV wvr_setImageWithURL:[NSURL URLWithString:self.cellInfo.videoModel.thubImage] placeholderImage:HOLDER_IMAGE];
    }
    self.titleL.text = self.cellInfo.videoModel.name;
    
    self.sizeL.text = [self videoSizeStr];
    
    [self.mDownView updateWithStatus:self.cellInfo.downStatus];
    [self initUpdateDownViewBlock];
}

-(void)initUpdateDownViewBlock{
    kWeakSelf(self);
    self.cellInfo.updateProgressBlock = ^(float progress){
        [weakself updateDownViewWithProgress:progress];
    };
    self.cellInfo.updateDownStatusBlock = ^(WVRSQDownViewStatus downStatus){
        if (downStatus == WVRSQDownViewStatusDowning) {
            [weakself updateDownViewWithProgress:weakself.cellInfo.videoModel.downProgress];
        }
        [weakself.mDownView updateWithStatus:downStatus];
    };
}

-(void)updateDownViewWithProgress:(CGFloat)progress
{
    if ([self.sizeL.text isEqualToString:@"0.00MB"]) {
        CGFloat totalSizeMB = self.cellInfo.videoModel.totalSize/1024.00/1024.00;
        if (totalSizeMB>=1024) {
            self.sizeL.text = [NSString stringWithFormat:@"%0.2fGB",totalSizeMB/1024];
        }else{
            self.sizeL.text = [NSString stringWithFormat:@"%0.2fMB",totalSizeMB];
        }
    }
    if (self.cellInfo.downStatus != WVRSQDownViewStatusPause) {
        [self.mDownView updateProgress:progress];
    }
}


-(NSString*)videoSizeStr
{
    NSString * str = @"";
    CGFloat totalSizeMB = self.cellInfo.videoModel.totalSize/1024.00/1024.00;
    if (totalSizeMB>=1024) {
        str = [NSString stringWithFormat:@"%0.2fGB",totalSizeMB/1024];
    }else{
        str = [NSString stringWithFormat:@"%0.2fMB",totalSizeMB];
    }
    return str;
}
@end
@implementation WVRSQCachCellInfo

@end
