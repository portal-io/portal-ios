//
//  WVRRNRCTBridge.m
//  WhaleyVR
//
//  Created by qbshen on 2018/1/17.
//  Copyright © 2018年 Snailvr. All rights reserved.
//

#import "WVRRNConfig.h"
#import <React/RCTBundleURLProvider.h>

@implementation WVRRNConfig

+ (instancetype)sharedInstance
{
    static WVRRNConfig *wvrRNConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wvrRNConfig = [[WVRRNConfig alloc] init];
    });
    return wvrRNConfig;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self configRCTBridgeWith:nil];
    }
    return self;
}

-(void)configRCTBridgeWith:(NSDictionary*)launchOptions
{
    if (self.gBridge) {
        NSLog(@"have bridge , should not create new");
        return;
    }
    NSURL *jsCodeLocation = nil;
//#ifdef DEBUG
//    jsCodeLocation = [NSURL
//                      URLWithString:@"http://172.29.2.1.xip.io:8081/index.bundle?platform=ios&dev=true&minify=false"];
//#else
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//#endif
    
    RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                              moduleProvider:nil
                                               launchOptions:launchOptions];
    _gBridge = bridge;
}

@end
