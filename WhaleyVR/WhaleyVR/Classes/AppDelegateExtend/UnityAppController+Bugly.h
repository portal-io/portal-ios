//
//  UnityAppController+Bugly.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "UnityAppController.h"
#import <Bugly/Bugly.h>

@interface UnityAppController (Bugly)<BuglyDelegate>

- (void)setupBugly;

@end
