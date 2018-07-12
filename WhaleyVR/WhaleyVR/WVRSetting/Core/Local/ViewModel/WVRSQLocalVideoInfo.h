//
//  WVRSQLocalVideoInfo.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRVideoModel.h"
#import "WVRSQBaseViewInfo.h"

@interface WVRSQLocalVideoInfo : WVRSQBaseViewInfo

@property (nonatomic, copy) void(^gotoPlayBlock)(WVRVideoModel *);
@property (nonatomic, copy) void(^completeBlock)(void);

- (void)setDelegateForTableView:(UITableView *)tableView;
- (void)loadVideosInfo;

@end
