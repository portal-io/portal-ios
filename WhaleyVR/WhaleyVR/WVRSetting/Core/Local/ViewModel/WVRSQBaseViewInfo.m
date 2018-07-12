//
//  WVRSQBaseViewInfo.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQBaseViewInfo.h"
#import "WVRNullCollectionViewCell.h"

@interface WVRSQBaseViewInfo ()
@property (nonatomic) WVRNullCollectionViewCell * mNullViewCellCach;

@end

@implementation WVRSQBaseViewInfo
-(void)showArrNullView:(NSString*)title icon:(NSString*)icon
{
    if (!self.mNullViewCellCach) {
        self.mNullViewCellCach = [[WVRNullCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
        [self.mNullViewCellCach resetImageToCenter];
        [self.mNullViewCellCach setTint:title];
        [self.mNullViewCellCach setImageIcon:icon];
    }
    [self.view addSubview:self.mNullViewCellCach];
}

-(void)clearNullView
{
    [self.mNullViewCellCach removeFromSuperview];
}

@end
