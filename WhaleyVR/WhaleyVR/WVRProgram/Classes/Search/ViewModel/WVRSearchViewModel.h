//
//  WVRSearchViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRSearchViewModel : WVRViewModel

@property (nonatomic, strong) NSString * keyWord;
@property (nonatomic, strong) NSString * type;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getSearchCmd;

@end
