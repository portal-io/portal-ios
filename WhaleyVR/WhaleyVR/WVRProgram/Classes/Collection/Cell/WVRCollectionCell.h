//
//  WVRCollectionCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"
#import "WVRCollectionModel.h"

@interface WVRCollectionCellInfo : SQTableViewCellInfo

@property (nonatomic) WVRCollectionModel * collectionModel;

@end
@interface WVRCollectionCell : SQBaseTableViewCell


@end
