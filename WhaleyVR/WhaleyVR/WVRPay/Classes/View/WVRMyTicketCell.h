//
//  WVRMyTicketCell.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRMyTicketListModel.h"

@protocol WVRMyTicketCellDelegate <NSObject>

@optional
//- (void)ticketCellLookupClick:(WVRMyTicketItemModel *)dataModel;

@end


@interface WVRMyTicketCell : UITableViewCell

//@property (nonatomic, weak) id<WVRMyTicketCellDelegate> realDelegate;
@property (nonatomic, strong) WVRMyTicketItemModel *dataModel;

@end


@interface WVRMyTicketHeader : UITableViewHeaderFooterView

@end
