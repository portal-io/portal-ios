//
//  WVRTVDetailBaseController.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRDetailVC.h"
#import "WVRTVDetailView.h"

//#import "WVRLoginTool.h"

@interface WVRTVDetailBaseController : WVRDetailVC

@property (nonatomic) WVRTVDetailView* mtvDetailV;

@property (nonatomic) WVRTVItemModel * httpItemModel;

- (void)networkFaild:(NSString *)errMsg;
//- (void)requestCollectionStatus;
- (void)loadSubView:(WVRTVItemModel *)itemModel;

- (void)valuationForVideoEntityWithModel:(WVRTVItemModel *)model;

- (WVRTVItemModel *)shouldCollectionModel;

@end
