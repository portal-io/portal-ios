//
//  WVRSQMoreReusableFooter.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSQRefreshReusableFooterInfo : SQCollectionViewFooterInfo

@property (nonatomic) WVRSectionModel * sectionModel;

@property (copy,nonatomic) void(^gotoBlock)(id);
@property (copy,nonatomic) void(^refreshBlock)(id);
@end
@interface WVRSQRefreshReusableFooter : SQBaseCollectionReusableFooter

@end
