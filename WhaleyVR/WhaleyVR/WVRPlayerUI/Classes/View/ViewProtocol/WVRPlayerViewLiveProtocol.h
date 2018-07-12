//
//  WVRPlayerViewLiveProtocol.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

@protocol WVRPlayerViewLiveDelegate <NSObject>

@required
- (void)actionEasterEggLottery;
- (void)actionGoGiftPage;
- (BOOL)actionCheckLogin;
- (void)actionGoRedeemPage;
- (BOOL)isKeyboardOn;

@end


