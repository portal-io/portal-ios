//
//  WVRErrorViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/18.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRErrorViewProtocol <NSObject>

- (void)setTryBlock:(void(^)(void))reloadBlock;

@end
