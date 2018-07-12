//
//  WVRSQCachVideoInfo.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRVideoModel.h"
#import "WVRSQBaseViewInfo.h"

@interface WVRCachVideoViewModel : WVRSQBaseViewInfo
@property (atomic) NSMutableArray * cachVideoArray;
@property (nonatomic) UIViewController * controller;

@property (nonatomic) BOOL isNullData;

@property (copy) void(^completeBlock)(void);
@property (copy) void(^gotoPlayBlock)(WVRVideoModel*);
@property (copy) void(^delAllBlock)(BOOL);

@property (copy) void(^editBlock)(void);

@property (copy) void(^selectBlock)(void);
@property (copy) void(^deselectBlock)(void);

//@property (nonatomic, copy) void(^backCompletionHandler)();

-(void)setDelegateForTableView:(UITableView*)tableView;
-(void)loadNetDBVideoInfo;

-(void)addDownTask:(WVRVideoModel*)videoModel;

-(void)setCanEdit:(BOOL)canEdit;

-(void)startDownWhenHaveNet;

-(void)doMultiDelete;

-(void)cancleCurDownload;

@end
