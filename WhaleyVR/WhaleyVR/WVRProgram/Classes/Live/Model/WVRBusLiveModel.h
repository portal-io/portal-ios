//
//  WVRBusLiveModel.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/9.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRBusLiveModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *playTime;

@property (nonatomic, strong) NSDate *createTime;

+ (void)getDanmuListFromCache:(void (^)(NSArray *msgArray))complation;

@end
