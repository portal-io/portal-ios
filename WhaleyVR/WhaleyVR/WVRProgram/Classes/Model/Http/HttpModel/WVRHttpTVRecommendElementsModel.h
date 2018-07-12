//
//  WVRHttpTVRecommendElementModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRHttpTVElementModel.h"

@interface WVRHttpTVRecommendElementsModel : NSObject
@property (nonatomic) NSString * number;
@property (nonatomic) NSString * numberOfElements;
@property (nonatomic) NSString * totalPages;
@property (nonatomic) NSString * size;
@property (nonatomic) NSString * last;
@property (nonatomic) NSString * totalElements;
@property (nonatomic) NSString * first;
@property (nonatomic) NSArray<WVRHttpTVElementModel*>* content;
@end
