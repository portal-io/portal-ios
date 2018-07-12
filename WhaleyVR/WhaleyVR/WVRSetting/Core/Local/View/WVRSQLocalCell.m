//
//  WVRSQLocalCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQLocalCell.h"
#import "SQTableViewDelegate.h"


@interface WVRSQLocalCell ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) SQTableViewDelegate * delegate;
@property WVRSQLocalCellInfo * cellInfo;
@end
@implementation WVRSQLocalCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.cellInfo = (WVRSQLocalCellInfo*)info;
    [self updateTableView];
}

-(void)updateTableView
{
    kWeakSelf(self);
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.delegate;
    [self.delegate loadData:^NSDictionary *{
        return weakself.cellInfo.mOriginDic;
    }];
    [self.tableView reloadData];
}


-(SQTableViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [SQTableViewDelegate new];
    }
    return _delegate;
}


@end
@implementation WVRSQLocalCellInfo
//-(CGSize)cellSize
//{
//    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//}
@end
