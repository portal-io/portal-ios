//
//  WVRLoadingViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WVRLoadingViewProtocol <NSObject>

- (void)showLoadingWithText:(NSString*)text;

-(void)hidenLoading;

@end
