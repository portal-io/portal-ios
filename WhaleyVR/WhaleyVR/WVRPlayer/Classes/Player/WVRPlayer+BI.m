//
//  WVRPlayer+BI.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayer+BI.h"
#import <objc/runtime.h>

@implementation WVRPlayer (BI)

static NSString *biSidKey = @"biSidKey";
static NSString *biVCKey = @"biVCKey";

- (void)setBiSid:(NSString *)biSid {
    
    objc_setAssociatedObject(self, &biSidKey, biSid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)biSid {
    
    return objc_getAssociatedObject(self, &biSidKey);
}

- (void)setBiVC:(NSString *)biVC {
    
    objc_setAssociatedObject(self, &biVCKey, biVC, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)biVC {
    
    return objc_getAssociatedObject(self, &biVCKey);
}

@end
