//
//  SQRefreshFooter.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQRefreshFooter.h"

@implementation SQRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    SQRefreshFooter * footer = [super footerWithRefreshingBlock:refreshingBlock];
    return footer;
}

@end
