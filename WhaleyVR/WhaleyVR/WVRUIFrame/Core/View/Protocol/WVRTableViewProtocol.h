//
//  WVRTableViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRListViewProtocol.h"
#import "WVRLoadingViewProtocol.h"

@protocol UITableViewDelegate,UITableViewDataSource;

@protocol WVRTableViewProtocol <WVRListViewProtocol, WVRLoadingViewProtocol>

- (void) setDelegate:(id<UITableViewDelegate>)delegate andDataSource:(id<UITableViewDataSource>)dataSource;

@end
