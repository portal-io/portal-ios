//
//  WVRScoreLabel.h
//  WhaleyVR
//
//  Created by Snailvr on 16/9/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRScoreLabel : UIView

@property (nonatomic, assign) float score;

- (instancetype)initWithScore:(float)score;

@end
