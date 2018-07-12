//
//  WVRShowGiftStrategy.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShowGiftStrategy.h"
#import "WVRMediator+Danmu.h"
#import "WVRReceiveGiftModel.h"
#import "WVRGiftAnimalViewCellViewModel.h"
#import "WVRGiftAnimalOperation.h"
#import "WVRGiftAnimalView.h"

#define KEY_GIFT_CACHE (@"key_giftCode_memberCode")
#define KEY_GIFT_COUNT_CACHE (@"key_giftCount")

@interface WVRShowGiftStrategy ()

@property (nonatomic, strong) NSOperationQueue * gOperationQueue1;
@property (nonatomic, strong) NSOperationQueue * gOperationQueue2;
@property (nonatomic, strong) NSOperationQueue * gOperationQueueUser1;
@property (nonatomic, strong) NSOperationQueue * gOperationQueueUser2;

/// 操作缓存池
@property (nonatomic,strong) NSCache *gOperationCache;
/// 维护用户礼物信息
@property (nonatomic,strong) NSCache *gUserGigtInfos;

@property (nonatomic, assign) NSInteger gCurUserIndex;

@property (nonatomic, strong) dispatch_queue_t queue ;

@end


@implementation WVRShowGiftStrategy

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("com.whaley.WVRShowGiftStrategy", NULL);
        kWeakSelf(self);
        void(^block)(NSDictionary *msg) = ^(NSDictionary *msg) {
            [weakself receiveGiftBlock:msg];
        };
        [[WVRMediator sharedInstance] WVRMediator_SetReceiveGiftBlockParams:@{@"receiveGiftMsgCallback":block}];
        
    }
    return self;
}

-(NSOperationQueue *)gOperationQueue1
{
    if (!_gOperationQueue1) {
        _gOperationQueue1 = [[NSOperationQueue alloc] init];
        _gOperationQueue1.maxConcurrentOperationCount = 1;
    }
    return _gOperationQueue1;
}

-(NSOperationQueue *)gOperationQueue2
{
    if (!_gOperationQueue2) {
        _gOperationQueue2 = [[NSOperationQueue alloc] init];
        _gOperationQueue2.maxConcurrentOperationCount = 1;
    }
    return _gOperationQueue2;
}

-(NSOperationQueue *)gOperationQueueUser1
{
    if (!_gOperationQueueUser1) {
        _gOperationQueueUser1 = [[NSOperationQueue alloc] init];
        _gOperationQueueUser1.maxConcurrentOperationCount = 1;
    }
    return _gOperationQueueUser1;
}

-(NSOperationQueue *)gOperationQueueUser2
{
    if (!_gOperationQueueUser2) {
        _gOperationQueueUser2 = [[NSOperationQueue alloc] init];
        _gOperationQueueUser2.maxConcurrentOperationCount = 1;
    }
    return _gOperationQueueUser2;
}

-(NSCache *)gOperationCache
{
    if (!_gOperationCache) {
        _gOperationCache = [[NSCache alloc] init];
    }
    return _gOperationCache;
}

-(NSCache *)gUserGigtInfos
{
    if (!_gUserGigtInfos) {
        _gUserGigtInfos = [[NSCache alloc] init];
    }
    return _gUserGigtInfos;
}

-(void)receiveGiftBlock:(NSDictionary *)msg
{
    WVRReceiveGiftModel * model = [WVRReceiveGiftModel yy_modelWithDictionary:msg];
//    int x = arc4random() % 9;
//    model.uid = [NSString stringWithFormat:@"%d",x];
//    dispatch_sync(self.queue, ^{
      [self addAnimationOpWithModel:model];
//    });
}

-(void)addAnimationOpWithModel:(WVRReceiveGiftModel* )model
{
    NSCache * modelCache = [self checkHaveCacheGiftModel:model];
    if (modelCache) {
        [self addAnimationOpWithModelForOldUsers:model];
    }else{
        [self addAnimationOpWithModelForNewUsers:model];
    }
}

-(NSCache*)checkHaveCacheGiftModel:(WVRReceiveGiftModel*)model
{
    NSMutableArray * userGiftModels = [self.gUserGigtInfos objectForKey:model.uid];
    for (NSCache * cur in userGiftModels) {
        if ([[cur objectForKey:KEY_GIFT_CACHE] isEqualToString:[self keyForCacheGiftModel:model]]) {
            return cur;
        }
    }
    return nil;
}

-(void)addAnimationOpWithModelForNewUsers:(WVRReceiveGiftModel* )model
{
//    if ([self.gOperationCache objectForKey:model.uid]) {
//        WVRGiftAnimalOperation * op = [self.gOperationCache objectForKey:model.uid];
//        op.gAnimalCellViewModel.giftCount++;
//    }else{
    NSLog(@"gift addAnimationOpWithModelForNewUsers");
        [self addNewUserAnimationOpWithModel:model withGiftCount:1];
        [self cacheUserGiftModels:1 giftModel:model];
//    }
}

-(void)addAnimationOpWithModelForOldUsers:(WVRReceiveGiftModel* )model
{
     NSCache * modelCache = [self checkHaveCacheGiftModel:model];
    NSInteger giftCount = [[modelCache objectForKey:KEY_GIFT_COUNT_CACHE] integerValue];
    if ([self.gOperationCache objectForKey:[self operationCacheKeyForModel:model]]) {
        NSLog(@"gift have operationCache");
        WVRGiftAnimalOperation * op = [self.gOperationCache objectForKey:[self operationCacheKeyForModel:model]];
        giftCount++;
        NSLog(@"gift have operationCache giftCount:%d",(int)giftCount);
        op.gAnimalCellViewModel.giftCount = (int)giftCount;
        [self cacheUserGiftModels:giftCount giftModel:model];
        if ([model.uid isEqualToString:[WVRUserModel sharedInstance].accountId]) {//是当前用户发送的礼物优先显示
            [op setQueuePriority:NSOperationQueuePriorityHigh];
//            [self mvCurUserToFront:op];
        }
    }else{
        NSLog(@"gift addNewUserAnimationOpWithModel");
        [self addNewUserAnimationOpWithModel:model withGiftCount:(int)giftCount];
    }
//    [self cacheUserGiftModels:giftCount giftModel:model];
}

-(void)addNewUserAnimationOpWithModel:(WVRReceiveGiftModel* )model withGiftCount:(int)giftCount
{
    WVRGiftAnimalViewCellViewModel * giftCellModel = [[WVRGiftAnimalViewCellViewModel alloc] init];
    giftCellModel.userId = model.uid;
    giftCellModel.userIcon = model.userHeadUrl;
    giftCellModel.userName = model.nickName;
    giftCellModel.giftIcon = model.giftIcon;
    giftCellModel.giftName = model.giftName;
    giftCellModel.toUserName = model.memberName;
    giftCellModel.giftCount = giftCount;
    WVRGiftAnimalOperation * op = [[WVRGiftAnimalOperation alloc] init];
    @weakify(op);
    @weakify(self);
    op.finishedBlock = ^(BOOL result, NSInteger finishCount) {
//        dispatch_sync(self.queue, ^{
            @strongify(op);
            @strongify(self);
            [self operationFinishBlock:op result:result finishCount:finishCount giftModel:model];
//        });
    };
//    op.gStartAnimationCmd = self.gAnimalViewModel.gStartAnimationCmd;
    op.gAnimalCellViewModel = giftCellModel;
    op.gAnimalViewModel = self.gAnimalViewModel;
    [op setQueuePriority:NSOperationQueuePriorityNormal];
    [self.gOperationCache setObject:op forKey:[self operationCacheKeyForModel:model]];
    [self addQueueWithOperation:op andUserId:model.uid];
}

-(NSString*)operationCacheKeyForModel:(WVRReceiveGiftModel*)giftModel
{
    NSString * opCacheKey = [[giftModel.uid stringByAppendingString:giftModel.giftCode] stringByAppendingString:giftModel.memberCode];
    NSLog(@"gift opCacheKey:%@",[[giftModel.nickName stringByAppendingString:giftModel.giftName] stringByAppendingString:giftModel.memberName]);
    return opCacheKey;
}

-(void)addQueueWithOperation:(WVRGiftAnimalOperation*)op andUserId:(NSString *)userId
{
    if ([userId isEqualToString:[WVRUserModel sharedInstance].accountId]) {//是当前用户发送的礼物优先显示
        [op setQueuePriority:NSOperationQueuePriorityHigh];
//        [self.gOperationQueue1 setSuspended:YES];
//        [self.gOperationQueue2 setSuspended:YES];
//        [self mvCurUserToFront:op];
    }
    if ([self compareQueue1:self.gOperationQueue1 withQueue2:self.gOperationQueue2]) {
        op.gAnimalCellViewModel.index = 1;
        [self.gOperationQueue2 addOperation:op];
    }else{
        op.gAnimalCellViewModel.index = 0;
        [self.gOperationQueue1 addOperation:op];
    }
}

-(BOOL)compareQueue1:(NSOperationQueue*)queue1 withQueue2:(NSOperationQueue*)queue2
{
    NSInteger queue1GiftCount = 0;
    for (WVRGiftAnimalOperation* cur in queue1.operations) {
        queue1GiftCount += cur.gAnimalCellViewModel.giftCount;
    }
    NSInteger queue2GiftCount = 0;
    for (WVRGiftAnimalOperation* cur in queue2.operations) {
        queue2GiftCount += cur.gAnimalCellViewModel.giftCount;
    }
    BOOL result = (queue1GiftCount > queue2GiftCount);
    return result;
}

//-(void)mvCurUserToFront:(WVRGiftAnimalOperation*)op
//{
//    if (self.gOperationQueue1.operations.count>self.gOperationQueue2.operations.count) {
//        op.gAnimalCellViewModel.index = 1;
//        NSArray * operations2 = self.gOperationQueue2.operations;
//        [self.gOperationQueue2 cancelAllOperations];
//        [self.gOperationQueue2 addOperation:op];
//        for (NSOperation* cur in operations2) {
//            if (!cur.isExecuting) {
//                [self.gOperationQueue2 addOperation:cur];
//            }
//        }
//    }else{
//        op.gAnimalCellViewModel.index = 0;
//        NSArray * operations1 = self.gOperationQueue1.operations;
//        [self.gOperationQueue1 cancelAllOperations];
//        [self.gOperationQueue1 addOperation:op];
//        for (NSOperation* cur in operations1) {
//            if (!cur.isExecuting) {
//                [self.gOperationQueue1 addOperation:cur];
//            }
//        }
//    }
//}

-(void)operationFinishBlock:(WVRGiftAnimalOperation*)op result:(BOOL)result finishCount:(NSInteger)finishCount giftModel:(WVRReceiveGiftModel*)giftModel
{
    NSLog(@"gift operationFinishBlock:%@",[self operationCacheKeyForModel:giftModel]);
    if (op.gAnimalCellViewModel.index==0) {
        self.gCurUserIndex = 0;
    }
    [self cacheUserGiftModels:finishCount giftModel:giftModel];
    
    // 延时删除用户礼物信息
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 动画完成之后,要移除动画对应的操作
        [self.gOperationCache removeObjectForKey:[self operationCacheKeyForModel:giftModel]];
        [self removeUserInfoCacheForGiftModel:giftModel];
//    });
    if ([op.gAnimalCellViewModel.userId isEqualToString:[WVRUserModel sharedInstance].accountId]) {
//        if (self.gOperationQueueUser2.operations.count==0) {
//            if (self.gOperationQueue2.isSuspended) {
//                [self.gOperationQueue2 setSuspended:NO];
//            }
//        }
//        if (self.gOperationQueueUser1.operations.count==0) {
//            if (self.gOperationQueue1.isSuspended) {
//                [self.gOperationQueue1 setSuspended:NO];
//            }
//        }
    }
}

-(void)removeUserInfoCacheForGiftModel:(WVRReceiveGiftModel *)giftModel
{
    NSLog(@"gift remove userInfoCache for %@",giftModel.uid);
    NSMutableArray * userGiftModels = [self.gUserGigtInfos objectForKey:giftModel.uid];
    NSCache * willRemoveCache = nil;
    for (NSCache * curCache in userGiftModels) {
        NSString * giftCode = [curCache objectForKey:KEY_GIFT_CACHE];
        if ([giftCode isEqualToString:[self keyForCacheGiftModel:giftModel]]) {
            willRemoveCache = curCache;
        }
    }
    if (willRemoveCache) {
        [userGiftModels removeObject:willRemoveCache];
    }
    if (!userGiftModels) {
        userGiftModels = [[NSMutableArray alloc] init];
    }
    [self.gUserGigtInfos setObject:userGiftModels forKey:giftModel.uid];
}

-(void)cacheUserGiftModels:(NSInteger)finishCount giftModel:(WVRReceiveGiftModel*)giftModel
{
    NSMutableArray * userGiftModels = [self.gUserGigtInfos objectForKey:giftModel.uid];
    if (!userGiftModels) {
        userGiftModels = [[NSMutableArray alloc] init];
    }
    for (NSCache * curCache in userGiftModels) {
        NSString * giftCode = [curCache objectForKey:KEY_GIFT_CACHE];
        if ([giftCode isEqualToString:[self keyForCacheGiftModel:giftModel]]) {
            [curCache setObject:@(finishCount) forKey:KEY_GIFT_COUNT_CACHE];
            return;
        }
    }
    NSCache * userGiftCache = [[NSCache alloc] init];
    [userGiftCache setObject:@(finishCount) forKey:KEY_GIFT_COUNT_CACHE];
    [userGiftCache setObject:[self keyForCacheGiftModel:giftModel] forKey:KEY_GIFT_CACHE];
    [userGiftModels addObject:userGiftCache];
    // 将礼物信息数量存起来
    NSLog(@"gift gUserGigtInfos set for %@",giftModel.uid);
    [self.gUserGigtInfos setObject:userGiftModels forKey:giftModel.uid];
}

-(NSString*)keyForCacheGiftModel:(WVRReceiveGiftModel*)giftModel
{
    NSString * giftCacheKey = [giftModel.giftCode stringByAppendingString:giftModel.memberCode];
    NSLog(@"gift giftCacheKey:%@",[giftModel.giftName stringByAppendingString:giftModel.memberName]);
    return giftCacheKey;
}
@end

