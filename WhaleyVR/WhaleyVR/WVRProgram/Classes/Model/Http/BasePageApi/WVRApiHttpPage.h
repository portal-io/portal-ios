//
//  WVRApiHttpPage.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

@interface WVRApiHttpPage : WVRAPIBaseManager
@property(nonatomic, assign) NSInteger nextPageNumber;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger numberOfElements;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger last;
@property (nonatomic, assign) NSInteger totalElements;
@property (nonatomic, assign) NSInteger first;
- (void)loadNextPage;//BOOL
@end
