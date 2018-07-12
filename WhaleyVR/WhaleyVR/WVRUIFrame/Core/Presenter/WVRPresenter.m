//
//  WVRPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenter.h"

@interface WVRPresenter ()

@property (nonatomic, weak) id<WVRViewProtocol> gView;

@end


@implementation WVRPresenter

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view {
    self = [super init];
    
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRViewProtocol)]) {
            self.gView = (id<WVRViewProtocol>)view;
        } else {
            NSException *exception = [[NSException alloc] initWithName:[self description] reason:@"view not conformsTo WVRViewProtocol" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)fetchData {
    
}

@end
