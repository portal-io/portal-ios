//
//  SQPageView.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQPageView : UIScrollView
-(void)addSubPageViews:(NSArray*)subViews y:(CGFloat)y;
-(void)updateFrame;
@end
