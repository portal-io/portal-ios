//
//  WVRHistoryViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRViewModel.h"

@class WVRHistoryModel,WVRSectionModel;

@interface WVRHistoryViewModel : WVRViewModel

@property (nonatomic, strong) NSString * delIds;

@property (nonatomic, strong, readonly) RACSignal * gHistoryCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gHistoryFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gHistoryDelCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gHistoryDelFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gHistoryDelAllCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gHistoryDelAllFailSignal;

-(RACCommand*)getHistoryCmd;
-(RACCommand*)getHistoryDelCmd;
-(RACCommand*)getHistoryDelAllCmd;


@end
