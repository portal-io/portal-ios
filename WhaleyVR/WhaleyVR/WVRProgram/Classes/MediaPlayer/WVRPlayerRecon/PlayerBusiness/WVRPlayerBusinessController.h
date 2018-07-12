//
//  WVRPlayerBusinessController.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WhaleyVRPlayer/WVRPlayer.h>

@protocol WVRPlayerBusinessController <NSObject>
- (void)attachWithSid:(NSString *)sid;
- (void)detach;
- (void)setVRPlayer:(id<VRPlayerDelegate>) player;
@end
