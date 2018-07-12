//
//  WVRPlayTopCellViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/10/13.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCellViewModel.h"
#import "WVRPlayerTopViewDelegate.h"

@interface WVRPlayTopCellViewModel : WVRPlayViewCellViewModel

@property (nonatomic, strong) NSString * title;

-(void)setDelegate:(id<WVRPlayerTopViewDelegate>)delegate;

-(id<WVRPlayerTopViewDelegate>)delegate;

@end
