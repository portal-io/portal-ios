//
//  WVRFilterManager.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRFilterManager : NSObject

+ (BOOL)shouldBlockURL:(NSURL *)url;

@end
