//
//  WVRPlayLiveCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/16.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"
#import "WVRPlayerTopViewDelegate.h"
#import "WVRPlayLiveTopViewDelegate.h"

@interface WVRPlayLiveTopCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * iconUrl;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *intro;

@property (nonatomic, assign) long playCount;
@property (nonatomic, assign) long beginTime;

@end
