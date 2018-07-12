//
//  WVRDramaPlayStrategy.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 策略类，承载互动剧播放逻辑

#import "WVRDramaPlayStrategy.h"

@interface WVRDramaPlayStrategy ()

@property (nonatomic, assign) BOOL tipIsShowed;

/// 当前供用户选择的结点
@property (atomic, strong) NSDictionary *waitSelectNodes;

@end


@implementation WVRDramaPlayStrategy

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetNodeTrack];
        [self installRAC];
    }
    return self;
}

- (void)installRAC {
    
    kWeakSelf(self);
    [RACObserve(self, detailModel) subscribeNext:^(id  _Nullable x) {
        if (x && !weakself.currentNode) {
            [weakself resetNodeTrack];
            weakself.currentNode = [weakself.detailModel startNode];
        }
    }];
}

- (void)resetNodeTrack {
    
    _nodeTrack = [NSMutableArray array];
}

- (void)setCurrentNode:(WVRDramaNodeModel *)currentNode {
    
    [self resetTipIsShowed];
    
    _lastNode = _currentNode;
    _currentNode = currentNode;
    
    if (currentNode) {
        
        [_nodeTrack addObject:currentNode];
    } else {
        [self resetNodeTrack];
    }
}

- (void)resetTipIsShowed {
    
    self.tipIsShowed = NO;
    self.waitSelectNodes = nil;
}

- (void)checkTipForSyncScrubber {
    
    if (self.currentNode.tipTime == 0) {
        return;
    }
    
    if (!self.vPlayer.isPlaying) {
        return;
    }
    
    long cureentPosition = [self.vPlayer getCurrentPosition];
    
    if (cureentPosition < self.currentNode.tipTime) {
        if (self.tipIsShowed) {
            
            [self tipShouldRemove];
        }
        
    } else {
        if (!self.tipIsShowed) {
            
            [self tipShouldShow];
        }
    }
}

- (void)checkTipForSeek:(long)seekTime {
    
    if (self.currentNode.tipTime == 0) {
        return;
    }
    
    if (seekTime < self.currentNode.tipTime) {
        [self tipShouldRemove];
        
    } else {
//        if (!self.tipIsShowed) {
//
//            [self tipShouldShow];
//        }
    }
}

- (BOOL)dealWithNodePlayCompletion {
    
    WVRDramaNodeModel *node = [self findNodeWithCode:self.currentNode.defaultItem];
    if (node) {
        
        [self playDefaultNode:node];
        return YES;
    }
    
    if (self.waitSelectNodes) {
        
        return YES;
    }
    
    return NO;
}

// MARK: - getter

- (BOOL)curIsFirstNode {
    
    if (self.currentNode == self.detailModel.startNode && self.nodeTrack.count == 1) {
        return YES;
    }
    
    return NO;
}

- (BOOL)curIsLastNode {
    
    if ([self.currentNode childrenCode].length == 0) {
        return YES;
    }
    
    NSArray<NSString *> *codes = [[self.currentNode childrenCode] componentsSeparatedByString:@"-"];
    NSMutableArray *realCodes = [NSMutableArray array];
    
    BOOL haveDefault = NO;
    for (NSString *code in codes) {
        WVRDramaNodeModel *child = [self findNodeWithCode:code];
        if (child) {
            [realCodes addObject:child];
            if ([self.currentNode.defaultItem isEqualToString:code]) {
                haveDefault = YES;
            }
        }
    }
    
    if (!haveDefault && realCodes.count < 2) {
        return YES;
    }
    
    return NO;
}

// MARK: - setter

- (void)setNodeTrackArray:(NSArray<NSString *> *)nodeTrack {
    
    long count = nodeTrack.count;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *code in nodeTrack) {
        WVRDramaNodeModel *node = [self findNodeWithCode:code];
        if (!node) {
            DDLogError(@"error: setNodeTrackArray: node == null");
            continue;
        }
        [arr addObject:node];
    }
    
    _nodeTrack = arr;
    
    NSString *lastObject = [nodeTrack lastObject];
    WVRDramaNodeModel *node = [self findNodeWithCode:lastObject];
    self.currentNode = node;
    if (nodeTrack.count >= 2) {
        NSString *object_2 = nodeTrack[count - 2];
        WVRDramaNodeModel *lastNode = [self findNodeWithCode:object_2];
        _lastNode = lastNode;
    } else {
        _lastNode = nil;
    }
}

//- (void)setUnityCurrentNode:(NSString *)nodeCode {
//    
//    WVRDramaNodeModel *node = [self findNodeWithCode:nodeCode];
//    
//    self.currentNode = node;
//}

- (void)setCurrentNodeForStart:(WVRDramaNodeModel *)node {
    
    self.currentNode = nil;
    self.currentNode = self.detailModel.startNode;
}

#pragma mark - private

// 通知UI显示Tip
- (void)tipShouldShow {
    
    self.tipIsShowed = YES;
    
    NSMutableDictionary *dict = [self getNextNodesInfo];
    
    if (!dict) {
        return;
    }
    self.playerUI.gDramasDic = dict;
    
    kWeakSelf(self);
    [self.playerUI.gChooseDramaSignal subscribeNext:^(id  _Nullable x) {
        
        [weakself userDidSelectNodeForKey:x];
    }];
    
    [self.playerUI updateDramaStatus:WVRPlayerToolVStatusWatingChooseDrama];
}

- (void)tipShouldRemove {
    
    [self resetTipIsShowed];
    
    [self.playerUI updateDramaStatus:WVRPlayerToolVStatusPreChooseDrama];
}

/// 获取接下来的剧情结点 给UIManager
- (NSMutableDictionary *)getNextNodesInfo {
    
    NSArray<NSString *> *codes = [[self.currentNode childrenCode] componentsSeparatedByString:@"-"];
    
    int count = 0;
    NSMutableDictionary *nodesInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *nodes = [NSMutableDictionary dictionary];
    
    for (NSString *code in codes) {
        
        if (count >= 3) { break; }      // 当前版本前端最多只能展示3个结点让用户选择
        
        WVRDramaNodeModel *child = [self findNodeWithCode:code];
        
        if (!child) { continue; }
        
        if (!self.currentNode.defaultVisible && [code isEqualToString:self.currentNode.defaultItem]) {
            // 设置了不可见，则不展示
            continue;
        }
        
        nodes[@(count)] = child;
        nodesInfo[@(count)] = child.smallPic;
        
        count ++;
    }
    
    if (nodesInfo.count <= 1) {
        return nil;
    }
    
    if (nodesInfo[@(2)] == nil) {
        nodesInfo[@(2)] = nodesInfo[@(1)];
        nodesInfo[@(1)] = nil;
        nodes[@(2)] = nodes[@(1)];
        nodes[@(1)] = nil;
    }
    
    self.waitSelectNodes = nodes;
    
    return nodesInfo;
}

- (WVRDramaNodeModel *)findNodeWithCode:(NSString *)code {
    
    if (code.length < 1) { return nil; }
    
    for (WVRDramaNodeModel *node in self.detailModel.nodes) {
        if ([node.code isEqualToString:code]) {
            return node;
        }
    }
    // 允许子剧情跳转回起始剧情
    if ([self.detailModel.startNode.code isEqualToString:code]) {
        return self.detailModel.startNode;
    }
    
    return nil;
}

- (void)userDidSelectNodeForKey:(id)key {
    
    if (!self.waitSelectNodes) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    WVRDramaNodeModel *node = self.waitSelectNodes[key];
    self.waitSelectNodes = nil;
    
    DDLogInfo(@"userDidSelectNodeForKey: %@", node.title);
    [self.playerUI updateDramaStatus:WVRPlayerToolVStatusChoosedDrama];
    if ([self.delegate respondsToSelector:@selector(playNextNode:isUserSelect:)]) {
        self.currentNode = node;
        [self.delegate playNextNode:node isUserSelect:YES];
    }
}

- (void)playDefaultNode:(WVRDramaNodeModel *)node {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.waitSelectNodes = nil;
    
    DDLogInfo(@"playDefaultNode: %@", node.title);
    [self.playerUI updateDramaStatus:WVRPlayerToolVStatusChoosedDrama];
    if ([self.delegate respondsToSelector:@selector(playNextNode:isUserSelect:)]) {
        self.currentNode = node;
        [self.delegate playNextNode:node isUserSelect:NO];
    }
}

@end
