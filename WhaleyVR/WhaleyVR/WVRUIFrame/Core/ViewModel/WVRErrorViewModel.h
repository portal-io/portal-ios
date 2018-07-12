//
//  WVRErrorViewModel.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRErrorViewModel : NSObject

@property (nonatomic, copy  ) NSString *errorCode;
@property (nonatomic, copy  ) NSString *errorMsg;

@property (nonatomic, strong) NSDictionary *errorInfo;

@end
