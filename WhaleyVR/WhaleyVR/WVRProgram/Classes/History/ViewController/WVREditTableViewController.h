//
//  WVREditTableViewController.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTableViewController.h"
#import "WVRNullCollectionViewCell.h"
#import "WVRDeleteFooterView.h"
#import "WVREditViewControllerProtocol.h"

@interface WVREditTableViewController : WVRTableViewController<WVREditViewControllerProtocol>

@property (nonatomic, strong) NSMutableDictionary * originDic;
@property (nonatomic) UIBarButtonItem * editItem;
@property (nonatomic) UIBarButtonItem * leftItem;
@property (nonatomic) WVRNullCollectionViewCell * mNullViewCellCach;
@property (nonatomic, strong) WVRDeleteFooterView * mDelFooterV;

@property (nonatomic, strong) NSMutableArray* mOriginArray;
@property (nonatomic, assign) BOOL selectAll;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) SQRefreshHeader * mJ_header;

@property (nonatomic, strong) SQTableViewDelegate * tableDelegate;

- (void)showArrNullView:(NSString*)title icon:(NSString*)icon;

- (void)clearNullView;

-(void)refreshUI;

@end
