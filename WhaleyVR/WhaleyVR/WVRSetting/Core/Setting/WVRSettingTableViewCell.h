//
//  WVRSettingTableViewCell.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/14/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WVRSettingTableViewCellStyle) {
    WVRSettingTableViewCellNull = 0,
    WVRSettingTableViewCellGoin,
    WVRSettingTableViewCellSwith,
    WVRSettingTableViewCellSegment
};

@interface WVRSettingTableViewCell : UITableViewCell

- (void)updateLeftLabel:(NSString*) left;
- (void)updateRightLabel:(NSString*) right;
- (void)updateWithViewStyle:(WVRSettingTableViewCellStyle)style;
    
@end
