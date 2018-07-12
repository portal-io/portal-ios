//
//  WVRPlayDramaCenterCellViewModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayDramaCenterCellViewModel.h"

@implementation WVRPlayDramaCenterCellViewModel

-(RACSignal *)chooseDramaSignal
{
    if (!_chooseDramaSignal) {
//        @weakify(self);
        _chooseDramaSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            @strongify(self);
            _gChooseDramaSubjcet = subscriber;
            return nil;
        }];
    }
    return _chooseDramaSignal;
}

@end
