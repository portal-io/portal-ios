//
//  WVRGiftCellAnimalOperation.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftCellAnimalOperation.h"
#import "WVRGiftAnimalViewCellViewModel.h"

@interface WVRGiftCellAnimalOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;


@end


@implementation WVRGiftCellAnimalOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

-(void)start
{
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    [self exeGiftCountAnimation];
    
}

- (void)exeGiftCountAnimation
{
    @weakify(self);
    self.gAnimalCellViewModel.shakeFinishedBlock = ^(BOOL result, NSInteger finishCount) {
        @strongify(self);
        self.finished = result;
        self.finishedBlock(YES, finishCount);
    };
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.gAnimalCellViewModel.gGiftCountAnimationCmd execute:self.gAnimalCellViewModel];
    }];
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
