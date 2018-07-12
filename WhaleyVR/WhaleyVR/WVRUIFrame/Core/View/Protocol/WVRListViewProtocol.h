//
//  WVRListViewProtocol.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVREmptyViewProtocol.h"
#import "WVRToastViewProtocol.h"
#import "WVRViewProtocol.h"

//一个列表展示View有哪些属性
@protocol WVRListViewProtocol <WVREmptyViewProtocol, WVRToastViewProtocol, WVRViewProtocol>

@optional

/**
 添加列表下拉时回调

 @param refreshBlock 回调block
 */
- (void) addHeaderRefresh:(void(^)(void))refreshBlock;


/**
 添加列表上拉回调

 @param moreBlock 回调block
 */
- (void) addFooterMore:(void(^)(void))moreBlock;


/**
 结束列表的刷新动画
 */
- (void) stopHeaderRefresh;


/**
 结束列表上拉动画

 @param noMore YES:表示没有更多数据的结束标签。NO:表示正常结束
 */
- (void) stopFooterMore:(BOOL)noMore;


/**
 刷新指定section

 @param sectionIndex 列表的section下标
 */
-(void)updateWithSectionIndex:(NSInteger)sectionIndex;


-(void)bindData:(id)originData;

- (void) reloadData;
@end
