//
//  main.m
//  WhaleyVR
//
//  Created by Snailvr on 16/7/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnityAppController.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        BOOL runningTests = (NSClassFromString(@"XCTest") != nil);
        if (!runningTests) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([UnityAppController class]));
        }
        else {
            return UIApplicationMain(argc, argv, nil, @"WVRTestAppDelegate");
        }
    }
}

