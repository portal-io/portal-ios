//
//  WVRSQMoreReusableFooter.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSQMore2ReusableFooterInfo : SQCollectionViewFooterInfo

@property (nonatomic) NSString * btnTitle;
@property (nonatomic) NSString * btnIcon;
@property (nonatomic) WVRSectionModel * sectionModel;

@property (copy,nonatomic) void(^gotoBlock)(id);
@property (copy,nonatomic) void(^refreshBlock)(id);
@end
@interface WVRSQMore2ReusableFooter : SQBaseCollectionReusableFooter

@end
