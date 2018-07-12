//
//  WVRSQCollectionReusableHeader.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRItemModel.h"

@interface WVRTVDetailHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic) BOOL isOpen;
@property (nonatomic) WVRItemModel * itemModel;

@end
@interface WVRTVDetailHeader : SQBaseCollectionReusableHeader

@end
