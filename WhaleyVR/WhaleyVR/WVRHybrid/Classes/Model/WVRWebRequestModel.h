//
//  WVRWebRequestModel.h
//  JockeyJS
//
//  Created by Wang Tiger on 16/10/21.
//  Copyright © 2016年 Corkboardme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRWebRequestModel : NSObject

@property (nonatomic, copy  ) NSString *url;
@property (nonatomic, copy  ) NSString *method;
@property (nonatomic, strong) NSArray<NSString *> *params;
@property (nonatomic, strong) NSArray<NSString *> *headers;

@end
