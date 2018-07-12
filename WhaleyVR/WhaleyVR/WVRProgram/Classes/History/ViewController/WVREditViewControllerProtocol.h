//
//  WVREditViewControllerProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVRSectionModel;

@protocol WVREditViewControllerProtocol <NSObject>

-(void)installRAC;

- (void)parseForDic;

-(void)loadDeleteFooterView;

-(void)changeToEditStatus;

-(void)changeToDefaultStatus;

-(void)didSelectAllCell:(BOOL)selected;

-(void)doMultiDelete;

-(void)updateSelectedCount;

-(void)alertForMutilDel;

-(void)removeDeleteFooterView;

-(void)httpSuccessBlock:(id)x;

-(void)httpFailBlock:(id)x;

-(SQTableViewSectionInfo *)getSectionInfo:(WVRSectionModel*)sectionModel;


- (BOOL)deleteItemBlock:(NSMutableArray*)cellInfos indexPath:(NSIndexPath*)indexPath;

- (void)multiDelete:(NSArray*)codes;

@optional
-(NSString*)nullViewTitle;

-(NSString*)nullViewIcon;

@end
