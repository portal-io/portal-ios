//
//  WVRRNRCTBridge.h
//  WhaleyVR
//
//  Created by qbshen on 2018/1/17.
//  Copyright © 2018年 Snailvr. All rights reserved.
//

#import <React/RCTBridge.h>

@interface WVRRNConfig : NSObject

@property (nonatomic, strong , readonly) RCTBridge * gBridge;

+ (instancetype)sharedInstance;

//-(void)configRCTBridgeWith:(NSDictionary*)launchOptions;

@end
