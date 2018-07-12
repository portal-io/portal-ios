//
//  WVRUpdateAdressHandle.h
//  WVRProgram
//
//  Created by Bruce on 2017/9/12.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRViewModel.h"

extern NSString * const kHttpParams_UpdateAddress_whaleyuid ;
extern NSString * const kHttpParams_UpdateAddress_username ;
extern NSString * const kHttpParams_UpdateAddress_province ;
extern NSString * const kHttpParams_UpdateAddress_city ;
extern NSString * const kHttpParams_UpdateAddress_county ;
extern NSString * const kHttpParams_UpdateAddress_address ;
extern NSString * const kHttpParams_UpdateAddress_mobile ;


@interface WVRUpdateAdressHandle : WVRViewModel

@property (nonatomic, strong) NSDictionary * params;


@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

@property (nonatomic, strong, readonly) RACCommand * gHttpCmd;

@end
