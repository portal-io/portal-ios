//
//  WVRAccountTableViewCell.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/2/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRTableViewCell.h"

@interface WVRMineCommonCell : WVRTableViewCell


- (void)updateRewardDoaV:(BOOL)hiden;
- (void)setBottomLineHidden;
- (void)updateCellWithIcon:(NSString *)icon
                     title:(NSString *)title
                  subTitle:(NSString*)subTitle
                      goin:(NSString *) goin;
@end
