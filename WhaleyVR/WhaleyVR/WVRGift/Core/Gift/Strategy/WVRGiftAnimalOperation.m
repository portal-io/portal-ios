//
//  WVRGiftAnimalOperation.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftAnimalOperation.h"
#import "WVRGiftAnimalViewCellViewModel.h"
#import "WVRGiftCellAnimalOperation.h"
#import "WVRGiftAnimalView.h"

@interface WVRGiftAnimalOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

//@property (nonatomic, assign) int curTotalGiftCount;

@property (nonatomic, strong) NSOperationQueue * gCountOperationQueue;

@end

@implementation WVRGiftAnimalOperation
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

-(NSOperationQueue *)gCountOperationQueue
{
    if (!_gCountOperationQueue) {
        _gCountOperationQueue = [[NSOperationQueue alloc] init];
        _gCountOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _gCountOperationQueue;
}

-(void)start
{
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
//    RAC(self,curTotalGiftCount) = RACObserve(self.gAnimalCellViewModel, giftCount);
    @weakify(self);
    [self exeAnimation];
    for (int i = 1; i <= self.gAnimalCellViewModel.giftCount; i++) {
        [self addGiftCellOp];
    }
    [[RACObserve(self.gAnimalCellViewModel, giftCount) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self addGiftCellOp];
    }];
//    self.gAnimalCellViewModel.g  = ^(BOOL result, NSInteger finishCount) {
//        @strongify(self);
//        if (self.curTotalGiftCount>0) {
//            [self exeAnimation];
//        }
//    };
    
}

- (void)addGiftCellOp
{
    NSLog(@"gift cell add op:%@ curCount:%d count%d",self,self.gAnimalCellViewModel.curGiftCount,self.gAnimalCellViewModel.giftCount);
    WVRGiftCellAnimalOperation * op = [[WVRGiftCellAnimalOperation alloc] init];
    op.gAnimalCellViewModel = self.gAnimalCellViewModel;
    op.finishedBlock = ^(BOOL result, NSInteger finishCount) {
        NSLog(@"gift cell opCount:%d",(int)self.gCountOperationQueue.operations.count);
    };
    [self.gCountOperationQueue addOperation:op];
}

- (void)exeAnimation
{
//    self.curTotalGiftCount --;
    @weakify(self);
    self.gAnimalCellViewModel.finishedBlock = ^(BOOL result, NSInteger finishCount) {
        @strongify(self);
        if (self.finishedBlock) {
            self.finishedBlock(result, finishCount);
        }
    };
    self.gAnimalCellViewModel.animalFinishedBlock = ^(BOOL result) {
        @strongify(self);
        self.finished = result;
    };
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //cell绑定cellViewModel
        if (self.gAnimalCellViewModel.index == 0) {
            self.gAnimalViewModel.gFirstGiftCellViewModel = self.gAnimalCellViewModel;
        }else{
            self.gAnimalViewModel.gSecGiftCellViewModel = self.gAnimalCellViewModel;
        }
        NSLog(@"gift cell gStartAnimationCmd:%@",self.gAnimalCellViewModel.gStartAnimationCmd);
        [self.gAnimalCellViewModel.gStartAnimationCmd execute:self.gAnimalCellViewModel];
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
