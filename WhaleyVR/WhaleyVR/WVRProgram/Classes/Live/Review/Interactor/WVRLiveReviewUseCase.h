//
//  WVRHomeTopBarListUseCase.h
//  WVRProgram
//
//  Created by qbshen on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <WVRUseCase.h>
#import "WVRHttpRecommendPageDetailModel.h"

@interface WVRLiveReviewUseCase : WVRUseCase<WVRUseCaseProtocol>

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * subCode;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end
