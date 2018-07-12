//
//  WVRSQMoreReusableFooter.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

typedef NS_ENUM(NSInteger , WVRSQMoreReusableFooterType) {
    WVRSQMoreReusableFooterTypeDefault,
    
};

@interface WVRSQMoreReusableFooterInfo : SQCollectionViewFooterInfo

@property (nonatomic) WVRSectionModel * sectionModel;

@property (nonatomic) WVRSQMoreReusableFooterType type;;

@property (copy, nonatomic) void(^gotoBlock)(id);
@property (copy, nonatomic) void(^refreshBlock)(id);

@end


@interface WVRSQMoreReusableFooter : SQBaseCollectionReusableFooter

@end
