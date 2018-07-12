//
//  WVRCollectionCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSetCellInfo : SQTableViewCellInfo

@property (nonatomic) WVRSectionModel * sectionModel;

@end


@interface WVRSetCell : SQBaseTableViewCell

@end
