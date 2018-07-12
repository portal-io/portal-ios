//
//  WVRHalfScreenPlayView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"
#import "WVRSectionModel.h"

@interface WVRHalfScreenPlayViewInfo : NSObject

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) CGRect frame;
@property (nonatomic) WVRSectionModel * sectionModel;

@end


@interface WVRHalfScreenPlayView : SQBaseView

+ (instancetype)createWithInfo:(WVRHalfScreenPlayViewInfo *)vInfo;

@end
