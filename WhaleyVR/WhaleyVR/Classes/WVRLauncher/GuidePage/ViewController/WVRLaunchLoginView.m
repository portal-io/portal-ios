//
//  WVRLaunchLoginView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLaunchLoginView.h"
#import <WhaleyVRPlayer/WVRPicture.h>

@interface WVRLaunchLoginView ()

@property (weak, nonatomic) IBOutlet UIButton *tryBtn;
- (IBAction)itemBtnOnClick:(id)sender;

@end


@implementation WVRLaunchLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tryBtn.titleLabel.font = kFontFitForSize(12.0f);
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        // 距底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    NSArray* subviews = self.subviews;
    for (UIView * view in subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            // 距底部0
            constraint.constant = fitToWidth(constraint.constant);
        }
    }
}

- (void)configPanoView:(UIViewController *)vc {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PanoramaLaunchImage.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    WVRPicture *pano = [[WVRPicture alloc] initWithContainerView:self MainController:vc];
    [pano updateTexture:image ?: [UIImage new]];
}

- (IBAction)itemBtnOnClick:(UIButton *)sender {
    UIButton * btn = (UIButton *)sender;
    if ([self.loginDelegate respondsToSelector:@selector(onClickItem:btn:)]) {
        [self.loginDelegate onClickItem:btn.tag btn:btn];
    }
}

- (void)dealloc {
    DDLogInfo(@"");
}

@end
