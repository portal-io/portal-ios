//
//  WVRFootballBannerViewSection.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballBannerViewSection.h"
#import "WVRSectionModel.h"

@implementation WVRFootballBannerViewSection
@section(([NSString stringWithFormat:@"%d",(int)WVRSectionModelTypeFootballBanner]),NSStringFromClass([WVRFootballBannerViewSection class]))

-(WVRBaseViewSection *)getSectionInfo:(WVRSectionModel *)sectionModel
{
    [super getSectionInfo:sectionModel];
    self.headerInfo.cellSize = CGSizeMake(SCREEN_WIDTH, fitToWidth(HEIGHT_AD_CELL));
    return self;
}
@end
