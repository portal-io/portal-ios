//
//  WVRFilterManager.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRFilterManager.h"

@implementation WVRFilterManager

+ (BOOL)shouldBlockURL:(NSURL *)url {
    
    NSString *str = url.absoluteString;
    NSLog(@"FilterManager - %@", str);
    
    if ([str hasPrefix:@"http"]) {
    
        if ([str hasSuffix:@".js"]) { return YES; }
        if ([str hasSuffix:@".css"]) { return YES; }
    }
    
    return NO;
}

@end
