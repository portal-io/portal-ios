//
//  WVRTableView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRListView.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"

@interface WVRTableView : WVRListView

@property (nonatomic, weak) id <UITableViewDataSource> dataSource;
@property (nonatomic, weak) id <UITableViewDelegate> delegate;

@property (nonatomic, strong) SQRefreshHeader * mj_header;


@property (nonatomic, strong) SQRefreshFooter *mj_footer;

@property (nonatomic, assign) BOOL allowsMultipleSelectionDuringEditing;

@property (nonatomic, readonly) NSArray<NSIndexPath *> *indexPathsForSelectedRows;

@property (nonatomic, readonly) NSInteger numberOfSections;

@property (nonatomic) CGFloat rowHeight;

@property (nonatomic, readonly) NSArray<__kindof UITableViewCell *> *visibleCells;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

//- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;


@end
