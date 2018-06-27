//
//  WVRSetAvatarViewModel.h
//  WVRAccount
//
//  Created by qbshen on 2017/9/13.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "WVRViewModel.h"

@interface WVRSetAvatarViewModel : WVRViewModel

@property (nonatomic, strong) NSData * fileData;
@property (nonatomic, strong) NSString * keyName;
@property (nonatomic, strong) NSString * fileName;


@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)setAvatarCmd;
@end
