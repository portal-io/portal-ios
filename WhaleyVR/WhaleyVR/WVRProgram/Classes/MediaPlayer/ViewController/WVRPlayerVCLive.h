//
//  WVRPlayerVCLive.h
//  WhaleyVR
//
//  Created by Bruce on 2017/5/3.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerVC.h"
#import "WVRVideoEntityLive.h"
#import "WVRPlayerLiveUIManager.h"

@interface WVRPlayerVCLive : WVRPlayerVC<WVRPlayerUILiveManagerDelegate>

- (WVRPlayerLiveUIManager *)playerUI;

- (void)liveDetailFailBlock;

- (void)requestForCommpents;

@end
