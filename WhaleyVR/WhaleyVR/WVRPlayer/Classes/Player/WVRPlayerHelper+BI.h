//
//  WVRPlayerHelper+BI.h
//  WhaleyVR
//
//  Created by Bruce on 2017/10/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerHelper.h"

@interface WVRPlayerHelper (BI)

@property (nonatomic, copy) NSString *biSid;

- (void)recordStartTime;

- (void)trackEventForStartPlay;
- (void)trackEventForEndPlay;
- (void)trackEventForPause;
- (void)trackEventForContinue;
- (void)trackEventForStartbuffer;
- (void)trackEventForEndbuffer;
//- (void)trackEventForLowbitrate;

@end
