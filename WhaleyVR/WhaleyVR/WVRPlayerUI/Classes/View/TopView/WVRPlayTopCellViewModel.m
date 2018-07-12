//
//  WVRPlayTopCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayTopCellViewModel.h"

@implementation WVRPlayTopCellViewModel
@synthesize delegate = _delegate;

-(void)setDelegate:(id<WVRPlayerTopViewDelegate>)delegate
{
    _delegate = delegate;
}

-(id<WVRPlayerTopViewDelegate>)delegate
{
    return _delegate;
}

@end
