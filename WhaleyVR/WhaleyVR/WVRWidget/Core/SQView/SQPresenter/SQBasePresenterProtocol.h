//
//  SQBasePresenterProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol SQBasePresenterProtocol <NSObject>

+ (instancetype)createPresenter:(id)createArgs;

- (UIView *)getView;

- (void)reloadData;

- (void)onDestroy;

@end
