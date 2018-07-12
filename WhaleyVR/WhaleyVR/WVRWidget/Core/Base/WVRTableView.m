//
//  WVRTableView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTableView.h"

@interface WVRTableView ()

@property (nonatomic, strong) UITableView * gContentView;

@end


@implementation WVRTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.gContentView = [[UITableView alloc] initWithFrame:frame style:style];
        [self addSubview:self.gContentView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gContentView.bounds = self.bounds;
    self.gContentView.center = self.center;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    
    self.gContentView.delegate = delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    
    self.gContentView.dataSource = dataSource;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    
    self.gContentView.separatorStyle = separatorStyle;
}

- (SQRefreshHeader *)mj_header {
    
    return (SQRefreshHeader*)self.gContentView.mj_header;
}

- (void)setMj_header:(SQRefreshHeader *)mj_header {
    
    self.gContentView.mj_header = mj_header;
}

- (SQRefreshFooter *)mj_footer {
    
    return (SQRefreshFooter*)self.gContentView.mj_footer;
}

- (void)setMj_footer:(SQRefreshFooter *)mj_footer {
    
    self.gContentView.mj_footer = mj_footer;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedRows {
    
    return self.gContentView.indexPathsForSelectedRows;
}

- (NSInteger)numberOfSections {
    
    return self.gContentView.numberOfSections;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return [self.gContentView numberOfRowsInSection:section];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    
    [self.gContentView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    
    [self.gContentView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    
    self.gContentView.rowHeight = rowHeight;
}

- (CGFloat)rowHeight {
    
    return self.gContentView.rowHeight;
}

- (NSArray<UITableViewCell *> *)visibleCells {
    
    return self.gContentView.visibleCells;
}

@end
