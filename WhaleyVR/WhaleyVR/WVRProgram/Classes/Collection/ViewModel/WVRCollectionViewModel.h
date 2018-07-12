//
//  WVRCollectionViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRViewModel.h"
#import "WVRTVItemModel.h"

@class WVRCollectionModel,WVRSectionModel;

@interface WVRCollectionViewModel : WVRViewModel

@property (nonatomic, strong) NSString * delIds;

@property (nonatomic, strong) WVRTVItemModel * saveModel;

@property (nonatomic, strong, readonly) RACSignal * gCollectionCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gCollectionFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gCollectionDelCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gCollectionDelFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gCollectionStatusCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gCollectionStatusFailSignal;

@property (nonatomic, strong, readonly) RACSignal * gCollectionSaveCompleteSignal;
@property (nonatomic, strong, readonly) RACSignal * gCollectionSaveFailSignal;

- (RACCommand *)getCollectionCmd;
- (RACCommand *)getCollectionDelCmd;
- (RACCommand *)getCollectionStatusCmd;
- (RACCommand *)getCollectionSaveCmd;


@end
