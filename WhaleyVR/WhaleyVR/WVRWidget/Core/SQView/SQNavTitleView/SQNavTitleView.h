//
//  SQNavTitleView.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SQNavTitleViewDelegate <NSObject>

@optional
-(void)onClick:(UIView*)view index:(NSInteger)index;

@end
@interface SQNavTitleView : UIView

@property (nonatomic) NSInteger selectIndex;
@property (weak,nonatomic) id<SQNavTitleViewDelegate> delegate;
-(void)updateWithTitles:(NSArray*)titles;

@end
