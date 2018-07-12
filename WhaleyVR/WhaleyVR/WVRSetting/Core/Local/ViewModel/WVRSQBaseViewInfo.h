//
//  WVRSQBaseViewInfo.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/1.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRSQBaseViewInfo : NSObject

@property (nonatomic) UIView * view;
-(void)showArrNullView:(NSString*)title icon:(NSString*)icon;
-(void)clearNullView;
@end
