//
//  WVRRNToastModule.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNToastModule.h"
#import <React/RCTBridgeModule.h>

@interface WVRRNToastModule()<RCTBridgeModule>

@end

@implementation WVRRNToastModule

- (NSDictionary *)constantsToExport
{
    return @{ @"SHORT": @(0),
              @"LONG": @(1),
              
              @"TOP": @(0),
              @"BOTTOM": @(1),
              @"CENTER": @(2),
              };
}

RCT_EXPORT_MODULE(WVRRNToastModule);

RCT_EXPORT_METHOD(show:(NSString*)text duration:(NSInteger)duration){
    [self showWithGravity:text duration:duration gravity:0];
}

RCT_EXPORT_METHOD(showWithGravity:(NSString*)text duration:(NSInteger)duration gravity:(NSInteger)gravity){
    if (text.length>0) {
        if (gravity==1) {
            SQToastBottomInKeyWindow(text);
        }else if (gravity == 2)
            SQToastInKeyWindow(text);
        else if (gravity == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController * vc = [UIViewController getCurrentVC];
                SQToastTOPIn(text, vc.view);
            });
        }
    }else{
        NSLog(@"WVRRNToastModule:show text is nil");
    }
}

+(BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
