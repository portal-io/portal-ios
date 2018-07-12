//
//  WVRCocoaHttpServerHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRCocoaHttpServerHeader_h
#define WVRCocoaHttpServerHeader_h

#define SQCocoaHttpServerBase (@"http://127.0.0.1:")
#define SQCocoaHttpServerPort (12345)
#define SQLibraryCache ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

#define SQVideoCacheFloder (@"/videoCach/")
#define SQCocoaHttpServerRoot ([SQLibraryCache stringByAppendingString:SQVideoCacheFloder])

#endif /* WVRCocoaHttpServerHeader_h */
