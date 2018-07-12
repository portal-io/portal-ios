//
//  WVRPlayer+BI.h
//  WhaleyVR
//
//  Created by Bruce on 2017/11/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <WhaleyVRPlayer/WVRPlayer.h>

@interface WVRPlayer (BI)

@property (nonatomic, copy) NSString *biSid;

/// 用弱引用ViewController可能会有野指针的问题，所以用字符串记录内存地址确保唯一
@property (nonatomic, copy) NSString *biVC;

@end
