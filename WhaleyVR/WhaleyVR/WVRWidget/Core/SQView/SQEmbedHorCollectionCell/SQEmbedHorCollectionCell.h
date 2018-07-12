//
//  SQEmbedCollectionCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@interface SQEmbedHorCollectionCellInfo : SQCollectionViewCellInfo

@property (strong,nonatomic) NSArray * cellNibNames;
@property (strong,nonatomic) NSArray * cellClassNames;
@property (nonatomic)  NSDictionary * originDic;
@property (nonatomic) BOOL canInto;

@property (nonatomic) void(^scrollBottomBlock)(void);

@end


@interface SQEmbedHorCollectionCell : UICollectionViewCell

@end
