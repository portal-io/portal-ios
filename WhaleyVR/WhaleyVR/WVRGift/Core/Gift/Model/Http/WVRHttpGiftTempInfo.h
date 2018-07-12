//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"
#import <UIKit/UIKit.h>

extern NSString * const kHttpParams_giftTempInfo_Code ;
extern NSString * const kHttpParams_giftTempInfo_pageNum ;
extern NSString * const kHttpParams_giftTempInfo_pageSize ;


@interface WVRHttpGiftTempInfo : WVRAPIBaseManager <WVRAPIManager>

@end
