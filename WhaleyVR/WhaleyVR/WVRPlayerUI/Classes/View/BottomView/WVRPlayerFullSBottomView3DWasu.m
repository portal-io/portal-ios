//
//  WVRPlayerFullSBottomView3DWasu.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSBottomView3DWasu.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"

@interface WVRPlayerFullSBottomView3DWasu ()

@property (weak, nonatomic) IBOutlet UIButton *defiButton;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)defiBtnOnClick:(id)sender;

@end


@implementation WVRPlayerFullSBottomView3DWasu

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = [WVRComputeTool sizeOfString:self.defiButton.titleLabel.text Size:CGSizeMake(800, 800) Font:self.defiButton.titleLabel.font];
    [self addLayerToButton:self.defiButton size:size];
}

//- (void)setClickDelegate:(id<WVRPlayerBottomViewDelegate>)clickDelegate {
//    
//    [super setClickDelegate:clickDelegate];
//}

- (void)addLayerToButton:(UIButton *)btn size:(CGSize)size {
    
    if (size.width == 0) {
        size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
    }
    
    CALayer *layer = [[CALayer alloc] init];
    float height = size.height + 6;
    float y = (btn.height - height) / 2.0;
    layer.frame = CGRectMake(0, y, btn.width, height);
    
    layer.cornerRadius = layer.frame.size.height / 2.0;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    [btn.layer insertSublayer:layer atIndex:0];
}

- (IBAction)defiBtnOnClick:(id)sender {
    if ([self.gViewModel.delegate respondsToSelector:@selector(chooseQuality)]) {
        [self.gViewModel.delegate chooseQuality];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self updateLeadingCons];
}
@end
