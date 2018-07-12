//
//  WVRSQFindMoreHeader.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRBaseModel.h"

@interface WVRSQFindMoreHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic) NSArray<WVRBaseModel *>* siteModels;

@end
@interface WVRSQFindMoreHeader : SQBaseCollectionReusableHeader

@end
