//
//  WVRPlayerDramaUIManager.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerUIManager.h"
#import "WVRDramaNodeModel.h"

#define KLEFT_DRAMA (@(0))
#define KMIDDLE_DRAMA (@(1))
#define KRIGHT_DRAMA (@(2))

@interface WVRPlayerDramaUIManager : WVRPlayerUIManager

@property (nonatomic, strong) RACSignal * gChooseDramaSignal;

@property (nonatomic, strong) NSMutableDictionary * gDramasDic;

- (void)updateDramaStatus:(WVRPlayerToolVStatus)status;

@end
