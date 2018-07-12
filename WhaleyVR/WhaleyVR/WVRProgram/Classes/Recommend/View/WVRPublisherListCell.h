//
//  WVRPublisherListCell.h
//  WhaleyVR
//
//  Created by Bruce on 2017/3/27.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRPublisherListCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *picUrl;

- (void)setDuration:(long)duration AndPlayCount:(long)playCount;

@end
