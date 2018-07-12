//
//  WVRSQCollectionReusableHeader.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSQMoreReusableHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic) WVRSectionModel * sectionModel;

@end
@interface WVRSQMoreReusableHeader : SQBaseCollectionReusableHeader

@end
