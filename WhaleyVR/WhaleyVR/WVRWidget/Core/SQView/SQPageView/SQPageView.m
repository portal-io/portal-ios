//
//  SQPageView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQPageView.h"

@interface SQPageView ()
@property CGFloat y;
@property (nonatomic) NSArray* mSubViews;
@end


@implementation SQPageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    
    return self;
}

-(void)addSubPageViews:(NSArray*)subViews y:(CGFloat)y
{
    self.y = y;
    self.mSubViews = subViews;
    for (UIView* cur in subViews) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        frame.origin.x = self.frame.size.width*[subViews indexOfObject:cur];
        cur.frame = frame;
        [self addSubview:cur];
    }
    self.contentSize = CGSizeMake(self.frame.size.width*subViews.count, self.frame.size.width);
}

-(void)updateFrame
{
    for (UIView* cur in self.mSubViews) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        frame.origin.x = self.frame.size.width*[self.mSubViews indexOfObject:cur];
        cur.frame = frame;
        [self addSubview:cur];
    }
    self.contentSize = CGSizeMake(self.frame.size.width*self.mSubViews.count, self.frame.size.height);
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    
//    if (self.contentOffset.x==0) {
//        return NO;
//    }else{
//        return YES;
//    }
//}


@end
