//
//  SQKitHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef SQKitHeader_h
#define SQKitHeader_h

#define SQNORMAL_SCREEN_WIDTH (375.f)

#define SQFITSCREEN(LENTH) (roundf(CGRectGetWidth([[UIScreen mainScreen] bounds]) / SQNORMAL_SCREEN_WIDTH*LENTH * 10) / 10.f)


#endif /* SQKitHeader_h */
