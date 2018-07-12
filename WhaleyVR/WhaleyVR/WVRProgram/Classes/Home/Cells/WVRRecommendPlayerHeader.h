//
//  WVRRecommendPlayerHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"


@interface WVRRecommendPlayerHeaderInfo : SQCollectionViewHeaderInfo

//@property (nonatomic, weak) UIViewController * controller;
@property (nonatomic, assign) BOOL needRload;

@property (nonatomic, copy) void(^reloadPlayerBlock)(void);

@end


@interface WVRRecommendPlayerHeader : SQBaseCollectionReusableHeader

@end
