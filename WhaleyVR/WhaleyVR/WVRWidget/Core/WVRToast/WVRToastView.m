//
//  WVRToastView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/26.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRToastView.h"

#define WVR_Toast_Margin (30.f)

@interface WVRToastView ()
@property (weak, nonatomic) IBOutlet UILabel *toastL;
@property (nonatomic, assign) CGFloat yScale;
@property (nonatomic, assign) CGFloat yBottom;
@end


@implementation WVRToastView

-(void)updateMsg:(NSString*)msg yBottom:(CGFloat)yBottom
{
    self.yBottom = yBottom;
    self.toastL.text = msg;
    [self layoutheight];
}

-(void)updateMsg:(NSString*)msg yScale:(CGFloat)yScale
{
    self.yScale = yScale;
    self.toastL.text = msg;
    [self layoutheight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutheight];
}

- (void)layoutheight
{
    CGSize sizeL = [WVRComputeTool sizeOfString:self.toastL.text Size:CGSizeMake(SCREEN_WIDTH-20-WVR_Toast_Margin, 2000.0) Font:[UIFont systemFontOfSize:15.f]];
    if (sizeL.height<36.0) {
        sizeL = [WVRComputeTool sizeOfString:self.toastL.text Size:CGSizeMake(2000.0,18) Font:[UIFont systemFontOfSize:15.f]];
        self.height = 18+20;
        self.width = sizeL.width+20;
        self.x = (self.superview.width-WVR_Toast_Margin-(sizeL.width+20))/2;
    }else{
        self.height = sizeL.height+20;
        self.x = WVR_Toast_Margin/2.f;
        self.width = self.superview.width-WVR_Toast_Margin;
    }
    
    NSLog(@"sizeL.width%f, height:%f", sizeL.width, sizeL.height);
//    if (sizeL.height<40.f) {//如果只有一行，高度固定，适配宽度
//
//    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2;
//    if (self.yBottom>0) {
//        self.bottomY = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-self.yBottom;
//    }else{
        self.centerY = self.superview.height*self.yScale-self.height/2;
//    }
}

- (BOOL)playerUINotAutoShow {
    
    return YES;
}

- (BOOL)playerUINotAutoHide {
    
    return YES;
}
@end
