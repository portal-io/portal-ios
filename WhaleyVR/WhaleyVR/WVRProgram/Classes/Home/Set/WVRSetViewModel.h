//
//  WVRCollectionModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRSectionModel.h"
#import "WVRError.h"
@class RACCommand, SQCollectionViewDelegate;

@interface WVRSetViewModel : WVRViewModel

@property (nonatomic, strong) NSString * title;

@property (nonatomic, assign, readonly) BOOL isMore;

@property (nonatomic, assign, readonly) BOOL haveMore;

@property (nonatomic, strong) NSMutableDictionary * gOriginDic;

@property (nonatomic, strong) WVRError * gError;

@property (nonatomic, strong, readonly) SQCollectionViewDelegate * gDelegate;

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong) NSString * subCode;


- (RACCommand *)refreshCmd ;

- (RACCommand *)moreCmd ;
@end
