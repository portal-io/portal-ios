//
//  WVRFootballViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFootballModel.h"

//typedef NS_ENUM(NSInteger, WVRFootballViewModelSectionType) {
//    WVRFootballViewModelSectionTypeAD,
//    WVRFootballViewModelSectionTypeLive,
//    WVRFootballViewModelSectionTypeRecord,
//    
//};

@class WVRSectionModel;

@interface WVRFootballViewModel : NSObject

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong, readonly) RACSignal * mCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * mFailSignal;

-(RACCommand*)getFootballCmd;

@end
