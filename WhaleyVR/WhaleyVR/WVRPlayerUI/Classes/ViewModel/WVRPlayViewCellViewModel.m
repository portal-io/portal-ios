//
//  WVRPlayViewCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"

@implementation WVRPlayViewCellViewModel
@synthesize delegate = _delegate;

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

-(id)delegate
{
    return _delegate;
}
@end
