//
//  WVRSearchResultsFor3DTableViewCell.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/26/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVRSortItemModel;

@interface WVRSearchResultsFor3DTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* thumbnail;

@property (nonatomic, strong) UILabel* title;

@property (nonatomic, strong) UILabel* director;

@property (nonatomic, strong) UILabel* actor;

@property (nonatomic, strong) UILabel* videoType;

@property (nonatomic, strong) UILabel* area;

- (void)updateUIWithModel:(WVRSortItemModel *) model;

@end
