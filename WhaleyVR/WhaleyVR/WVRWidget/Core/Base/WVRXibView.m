//
//  WVRXibView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRXibView.h"

@implementation WVRXibView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self loadView];
    }
    return self;

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

-(NSString*)getXibName
{
    NSString * className = NSStringFromClass(self.classForCoder);
    
    return className;
}

-(void)loadView
{
    if (self.contentView != nil) {
        return;
    }
    self.contentView = [self loadViewWithNibName:[self getXibName] owner:self];
    [self addSubview:self.contentView];
}

-(UIView*)loadViewWithNibName:(NSString*)fileName owner:(id)owner{
    NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:fileName owner:owner options:nil];
    return [nibs firstObject];
}


@end
