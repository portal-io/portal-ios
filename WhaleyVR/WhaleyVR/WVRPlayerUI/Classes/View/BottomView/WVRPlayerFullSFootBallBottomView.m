//
//  WVRPlayerFullSFootBallBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerFullSFootBallBottomView.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"

@interface WVRPlayerFullSFootBallBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)defiBtnOnClick:(id)sender;

@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRPlayerFullSFootBallBottomView
@synthesize isFootball = _isFootball;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = [WVRComputeTool sizeOfString:self.defiButton.titleLabel.text Size:CGSizeMake(800, 800) Font:self.defiButton.titleLabel.font];
    [self addLayerToButton:self.defiButton size:size];
    
//    [self setIsFootball:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self updateLeadingCons];
}

- (void)installRAC
{
    [super installRAC];
    @weakify(self);
    [self.defiButton setTitle:((WVRPlayBottomCellViewModel*)self.gViewModel).defiTitle forState:UIControlStateNormal];
    [[RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), defiTitle) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.defiButton setTitle:((WVRPlayBottomCellViewModel*)self.gViewModel).defiTitle forState:UIControlStateNormal];
    }];
}

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
    // 新增需求，足球不支持切换清晰度
    if (_isFootball) {
        SQToastInKeyWindow(kToastNoChangeDefinition);
        return;
    }
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(chooseQuality)]) {
        [self.gViewModel.delegate chooseQuality];
    }
}

- (IBAction)cameraBtnClick:(UIButton *)sender {

    if (self.cameraStandBtns) {

        [self removeCameraStandBtns];

    } else {

        NSArray *arr = nil;
        if ([self.gViewModel.delegate respondsToSelector:@selector(actionGetCameraStandList)]) {
            arr = [self.gViewModel.delegate actionGetCameraStandList];
        }

        NSMutableArray *btnArr = [NSMutableArray array];
        
        float buttonX = 0;
        {
            NSDictionary *lastDic = [arr lastObject];
            
            WVRCameraChangeButton *tmpBtn = [[WVRCameraChangeButton alloc] init];
            
            tmpBtn.standType = [[lastDic allKeys] firstObject];
            [tmpBtn setTitle:tmpBtn.standType forState:UIControlStateNormal];
            buttonX = sender.centerX - tmpBtn.width * 0.5;      // 新需求，最下面一个button和机位btn中心对齐
        }
        
        int j = (int)arr.count;
        for (NSDictionary *dict in arr) {

            WVRCameraChangeButton *btn = [[WVRCameraChangeButton alloc] init];

            btn.x = buttonX;
            btn.y = sender.y - (adaptToWidth(10) + btn.height) * j;
            btn.standType = [[dict allKeys] firstObject];
            [btn setTitle:btn.standType forState:UIControlStateNormal];
            btn.isSelect = [[[dict allValues] firstObject] boolValue];

            [btn addTarget:self action:@selector(changeCameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:btn];
            [btnArr addObject:btn];
            
            j -= 1;
        }
        _cameraStandBtns = btnArr;
    }
}

- (void)changeCameraBtnClick:(WVRCameraChangeButton *)sender {
    
//    [self removeCameraStandBtns];
    
    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = (btn == sender);
    }
    
    if ([self.gViewModel.delegate respondsToSelector:@selector(actionChangeCameraStand:)]) {
        [self.gViewModel.delegate actionChangeCameraStand:sender.standType];
    }
}

- (void)removeCameraStandBtns {
    for (UIButton *btn in _cameraStandBtns) {
        [btn removeFromSuperview];
    }
    _cameraStandBtns = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.hidden == NO) {        // 修复隐藏后还有效果的bug
        
        for (UIButton *btn in _cameraStandBtns) {
            CGPoint buttonPoint = [btn convertPoint:point fromView:self];
            if ([btn pointInside:buttonPoint withEvent:event]) {
                return btn;
            }
        }
    }
    
    UIView * view = [super hitTest:point withEvent:event];
    return view;
}

- (NSString *)cameraPoint {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    
    CGPoint point = [self convertPoint:_cameraBtn.center toView:window];
    
    return NSStringFromCGPoint(point);
}

@end
