//
//  WVRMyTicketViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRMyTicketViewModel : WVRViewModel

@property (nonatomic, strong) NSString * page;

@property (nonatomic, strong) NSString * size;

@property (nonatomic, strong, readonly) RACSignal * gSuccessSignal;
@property (nonatomic, strong, readonly) RACSignal * gFailSignal;

- (RACCommand *)myTicketCmd;

@end
