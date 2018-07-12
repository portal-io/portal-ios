//
//  WVRSQFindMoreHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQFindMoreHeader.h"
#import "SQSegmentView.h"

@interface WVRSQFindMoreHeader ()
@property (nonatomic) WVRSQFindMoreHeaderInfo * cellInfo;
@property (weak, nonatomic) IBOutlet SQSegmentView *segmentV;

@end


@implementation WVRSQFindMoreHeader

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    self.cellInfo = (WVRSQFindMoreHeaderInfo *)info;
    
//    NSArray* titles = [self parseSiteTitles];
//    if (titles.count>0) {
//        self.segmentV.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
//        self.segmentV.sectionTitles = titles;
//    }
}

@end


@implementation WVRSQFindMoreHeaderInfo

@end
