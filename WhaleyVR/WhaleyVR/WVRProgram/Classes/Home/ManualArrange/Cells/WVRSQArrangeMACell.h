//
//  WVRSQArrangeMACell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSQArrangeMACellInfo : SQCollectionViewCellInfo

//@property (nonatomic) WVRItemModel * itemModel;

@property (nonatomic, copy) void(^playBlock)(void);
@property (nonatomic, copy) void(^gotoDetailBlock)(void);

@property (nonatomic, strong) NSURL * iconUrl;

@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) NSString * intrDesL;

@property (nonatomic, assign) BOOL packageItemCharged;

- (void)convert:(WVRItemModel *)itemModel;

@end


@interface WVRSQArrangeMACell : SQBaseCollectionViewCell

@property (nonatomic, weak) WVRItemModel *itemModel;

@end
