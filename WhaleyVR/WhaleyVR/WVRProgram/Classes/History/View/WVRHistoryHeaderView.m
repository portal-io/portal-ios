//
//  WVRHistoryHeaderView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryHeaderView.h"

@interface WVRHistoryHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
@implementation WVRHistoryHeaderView

-(void)fillData:(SQBaseTableViewInfo *)info
{
    self.titleL.text = info.args;
}
@end
@implementation WVRHistoryHeaderViewInfo

@end
