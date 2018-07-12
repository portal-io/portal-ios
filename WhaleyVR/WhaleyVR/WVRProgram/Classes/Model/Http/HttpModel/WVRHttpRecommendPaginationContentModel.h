//
//  WVRHttpRecommendPaginationContentModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRHttpRecommendPageDetailModel.h"

@interface WVRHttpRecommendPaginationContentModel : NSObject

@property (nonatomic) NSString * number;
@property (nonatomic) NSString * numberOfElements;
@property (nonatomic) NSString * totalPages;
@property (nonatomic) NSString * size;
@property (nonatomic) NSString * last;
@property (nonatomic) NSString * totalElements;
@property (nonatomic) NSString * first;
@property (nonatomic) NSArray<WVRHttpRecommendElement *>* content;

@end
