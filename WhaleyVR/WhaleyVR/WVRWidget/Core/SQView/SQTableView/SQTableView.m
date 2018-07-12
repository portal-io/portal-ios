//
//  SQTableView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableView.h"

@implementation SQTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
@end
