//
//  WVRSQTagHorCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@interface WVRSQTagHorCellInfo : SQCollectionViewCellInfo
@property (strong,nonatomic) NSArray * cellNibNames;
@property (strong,nonatomic) NSArray * cellClassNames;
@property (strong,nonatomic) NSArray * headerNibNames;
@property (nonatomic, assign) BOOL noSplitV;
@property (nonatomic)  NSDictionary * originDic;

@end
@interface WVRSQTagHorCell : SQBaseCollectionViewCell

@end
