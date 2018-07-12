//
//  WVRShowFieldModel.h
//  WhaleyVR
//
//  Created by Bruce on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRAPIConst.h"
#import "WVRShowFieldRoomModel.h"

@interface WVRShowFieldModel : NSObject

+ (void)requestForShowFieldBannerList:(APIResponseBlock)block;
+ (void)requestForShowFieldList:(APIResponseBlock)block;

@end
