//
//  WVRBaseView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQBaseView.h"


@interface WVRBaseViewInfo : NSObject

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) CGRect frame;


@end
@interface WVRBaseView : SQBaseView

@end
