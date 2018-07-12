//
//  Target_program.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_Currency : NSObject

- (UIViewController *)Action_nativeCurrencyConfigViewController:(NSDictionary *)params;

- (void)Action_nativeGetUserWCBalance:(NSDictionary *)params;

- (void)Action_nativeBuyWithWhaleyCurrency:(NSDictionary *)params;

@end
