//
//  WVRPageView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPageView.h"
#import "UIView+Extend.h"

@interface WVRPageView ()

@property (nonatomic, assign) NSInteger mSubViewsNumber;

@end


@implementation WVRPageView
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
}

-(void)reloadData {
    
    NSInteger number = [self.dataSource numberOfPage:self];
//    if (number != self.mSubViewsNumber) {
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    self.mSubViewsNumber = number;
    for (int i = 0; i < number; i++) {
        UIView * view = [self.dataSource subView:self forIndex:i];
        view.frame = self.bounds;
        view.x = self.width*i;
        [self addSubview:view];
    }
    self.contentSize = CGSizeMake(self.width*number, self.height);
//    }
}

-(void)addSubPageViews:(NSArray*)subViews y:(CGFloat)y
{
    self.y = y;
    
    for (UIView* cur in subViews) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        frame.origin.x = self.frame.size.width*[subViews indexOfObject:cur];
        cur.frame = frame;
        [self addSubview:cur];
    }
    self.contentSize = CGSizeMake(self.frame.size.width*subViews.count, self.frame.size.width);
}


-(void)setDelegate:(id<WVRPageViewDelegate>)delegate
{
    [super setDelegate:delegate];
    _delegate = delegate;
}

@end
