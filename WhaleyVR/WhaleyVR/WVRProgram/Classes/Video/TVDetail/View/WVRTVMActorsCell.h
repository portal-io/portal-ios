//
//  WVRTVMActorsCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRItemModel.h"

@interface WVRTVMActorsCellInfo : SQCollectionViewCellInfo

@property (nonatomic) WVRItemModel * model;

@end
@interface WVRTVMActorsCell : SQBaseCollectionViewCell

@end
