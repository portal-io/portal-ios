//
//  WVRSQTagCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRTagModel.h"

@interface WVRTagHotCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRTagModel * tagModel;

@end
@interface WVRTagHotCell : SQBaseCollectionViewCell

@end
