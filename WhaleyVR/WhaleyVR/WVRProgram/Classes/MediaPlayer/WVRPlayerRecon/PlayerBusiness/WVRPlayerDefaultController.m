//
//  WVRPlayerDefaultController.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerDefaultController.h"

@interface WVRPlayerDefaultController ()
@property(nonatomic, strong) NSMutableArray *controllerArray;

@end

@implementation WVRPlayerDefaultController

- (void)attachWithSid:(NSString *)sid
{
    if (_controllerArray != nil && [_controllerArray count] > 0) {
        for (int i =0; i < [_controllerArray count]; i++) {
            id<WVRPlayerBusinessController> controller = [_controllerArray objectAtIndex:i];
            [controller attachWithSid:sid];
        }
    }
}

- (void)detach
{
    if (_controllerArray != nil && [_controllerArray count] > 0) {
        for (int i =0; i < [_controllerArray count]; i++) {
            id<WVRPlayerBusinessController> controller = [_controllerArray objectAtIndex:i];
            [controller detach];
            [controller setVRPlayer:nil];
        }
    }
}

- (void)setVRPlayer:(id<VRPlayerDelegate>)player
{
    if (_controllerArray != nil && [_controllerArray count] > 0) {
        for (int i =0; i < [_controllerArray count]; i++) {
            id<WVRPlayerBusinessController> controller = [_controllerArray objectAtIndex:i];
            [controller setVRPlayer:player];
        }
    }
}

- (void)addController:(id<WVRPlayerBusinessController>) controller
{
    if (_controllerArray == nil) {
        _controllerArray = [[NSMutableArray alloc] init];
    }
    [_controllerArray addObject:controller];
}

- (void)removeController:(id<WVRPlayerBusinessController>) controller
{
    if (_controllerArray != nil) {
        [_controllerArray removeObject:controller];
    }
}

- (void)clearController
{
    if (_controllerArray != nil) {
        [_controllerArray removeAllObjects];
    }
}
@end
