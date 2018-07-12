//
//  WVRLiveRecBannerItemView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRLiveRecBannerItemView : UIView
/**
 *  主图
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
//@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@end
