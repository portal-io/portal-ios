//
//  SQBannerView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQBannerView.h"
#import <SDWebImage/SDCycleScrollView.h>
#import "UIView+Extend.h"
#import "WVRAppContextHeader.h"
#import "WVRSpring2018Manager.h"

@interface SQBannerView ()

@property (nonatomic) SDCycleScrollView * sdcsView;

@end


@implementation SQBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSdcsView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.sdcsView.bounds = CGRectMake(0, 0, self.width, self.height);
    self.sdcsView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)initSdcsView {
    
    kWeakSelf(self);
    self.sdcsView = [[SDCycleScrollView alloc] initWithFrame:self.frame];
    self.sdcsView.autoScrollTimeInterval = 4;
    self.sdcsView.titleLabelHeight = fitToWidth(40);
    self.sdcsView.titleLabelTextFont = [UIFont systemFontOfSize:fitToWidth(14)];
    self.sdcsView.pageControlBottomOffset = -5;
    self.sdcsView.placeholderImage = [UIImage imageNamed:@"defaulf_holder_image"];
    self.sdcsView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.sdcsView.pageControlDotSize = CGSizeMake(fitToWidth(5), fitToWidth(5));
    self.sdcsView.currentPageDotImage = [UIImage imageNamed:@"icon-banner_dot_choose"];
    self.sdcsView.pageDotImage = [UIImage imageNamed:@"icon-banner_dot_default"];
    self.sdcsView.clickItemOperationBlock = ^(NSInteger index) {
        if (weakself.onClickItemBlock) {
            weakself.onClickItemBlock(index);
        }
    };
//    if ([WVRSpring2018Manager checkSpring2018Valid]) {
//        // pod 此处需要pod update
//        self.sdcsView.activityImage = [UIImage imageNamed:@"icon_spring_banner_layer"];
//    }
    
    self.updateAutoScroll = ^(BOOL isAuto) {
        weakself.sdcsView.autoScroll = isAuto;
    };
    [self addSubview:self.sdcsView];
//    [WVRLayoutConstraintTool addTBLRViewCont:self.sdcsView inSec:self];
}

- (void)updateWithData:(NSArray *)imageUrls titles:(NSArray *)titles localImageNames:(NSArray *)localImageNames {
    
    if (imageUrls)
        self.sdcsView.imageURLStringsGroup = imageUrls;
    if (titles)
        self.sdcsView.titlesGroup = titles;
    if (localImageNames)
        self.sdcsView.localizationImageNamesGroup = localImageNames;
}

@end
