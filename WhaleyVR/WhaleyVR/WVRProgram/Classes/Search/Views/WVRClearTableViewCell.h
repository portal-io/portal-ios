//
//  WVRClearTableViewCell.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/26/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRClearTableViewCellDelegate <NSObject>

- (void)clearHistoryKeyword;

@end

@interface WVRClearTableViewCell : UITableViewCell

@property (nonatomic, weak) id<WVRClearTableViewCellDelegate> delegate;

@end
