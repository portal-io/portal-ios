//
//  WVRTopBarViewModel.h
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRArrangeViewModel : WVRViewModel

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getArrangeCmd;

@end
