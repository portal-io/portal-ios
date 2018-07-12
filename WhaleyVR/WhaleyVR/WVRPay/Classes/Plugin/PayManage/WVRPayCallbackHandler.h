//
//  WVRPayCallbackHandler.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface WVRPayCallbackHandler : NSObject

@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * payMethod;

@property (nonatomic, strong, readonly) RACSignal * successSignal;
@property (nonatomic, strong, readonly) RACSignal * failSignal;

- (RACCommand *)payCallbackCmd;

@end
