//
//  WVRMineSplitCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMineSplitCell.h"

@interface WVRMineSplitCell ()



@end
@implementation WVRMineSplitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = k_Color10;
    }
    return self;
}
-(void)bindViewModel:(id)viewModel
{
    
}

@end
