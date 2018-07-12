//
//  WVRFindNavBarView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRXibView.h"

@interface WVRFindNavBarView : WVRXibView

@property (nonatomic, copy) void(^startSearchClickBlock)(void);
@property (nonatomic, copy) void(^cacheClickBlock)(void);
@property (nonatomic, copy) void(^historyClickBlock)(void);

@end
