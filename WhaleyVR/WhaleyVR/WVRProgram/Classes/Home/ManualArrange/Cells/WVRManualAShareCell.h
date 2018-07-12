//
//  WVRManualAShareCell.h
//  WhaleyVR
//
//  Created by qbshen on 2017/4/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@interface WVRManualAShareCellInfo : SQCollectionViewCellInfo

@property (nonatomic, strong) NSString * localImageStr;
@property (nonatomic, strong) NSString * title;

@end


@interface WVRManualAShareCell : SQBaseCollectionViewCell

@end
