//
//  SQRefreshHeader.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQRefreshHeader.h"

@implementation SQRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    SQRefreshHeader * refreshHeader = [super headerWithRefreshingBlock:refreshingBlock];
    refreshHeader.stateLabel.hidden = YES;
    return refreshHeader;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    
    SQRefreshHeader * refreshHeader = [super headerWithRefreshingTarget:target refreshingAction:action];
    refreshHeader.stateLabel.hidden = YES;
    return refreshHeader;
}

@end
