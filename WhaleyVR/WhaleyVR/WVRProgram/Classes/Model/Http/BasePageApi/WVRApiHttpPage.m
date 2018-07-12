//
//  WVRApiHttpPage.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRApiHttpPage.h"

@interface WVRApiHttpPage ()

@end

@implementation WVRApiHttpPage

#pragma mark - private method
- (void)loadNextPage
{
    if (self.isLoading) {
        return;
    }
    if (self.last) {
        return;
    }
    
    if (self.nextPageNumber > 0 && self.nextPageNumber <= self.totalPages) {
        [self loadData];
    }
}

#pragma mark - WVRAPIBaseManager
- (BOOL)beforePerformSuccessWithResponse:(WVRNetworkingResponse *)response
{
    [super beforePerformSuccessWithResponse:response];
    NSDictionary *content = response.content[@"data"];
    self.number = [content[@"number"] integerValue];
    self.numberOfElements = [content[@"numberOfElements"] integerValue];
    self.totalPages = [content[@"totalPages"] integerValue];
    self.size = [content[@"size"] integerValue];
    self.last = [content[@"last"] integerValue];
    self.totalElements = [content[@"totalElements"] integerValue];
    self.first = [content[@"first"] integerValue];
    
    self.nextPageNumber++;
    return YES;
}

- (BOOL)beforePerformFailWithResponse:(WVRNetworkingResponse *)response
{
    [super beforePerformFailWithResponse:response];
    if (self.nextPageNumber > 0) {
        self.nextPageNumber--;
    }
    return YES;
}

@end
