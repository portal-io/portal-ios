//
//  WVRContentRecommendationSupernatant.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 内容推荐浮层

#import "WVRContentRecommendationSupernatant.h"
#import "WVRGotoNextTool.h"
#import "WVRProgramBIModel.h"
#import "WVRSQLiteManager.h"
#import "WVRLaunchFlowManager.h"
#import "WVRCircleProgressButton.h"

@interface WVRContentRecommendationSupernatant ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) WVRCircleProgressButton *closeBtn;

@property (nonatomic, strong) WVRRecommendItemModel *dataModel;

@end


@implementation WVRContentRecommendationSupernatant

- (instancetype)initWithModel:(WVRRecommendItemModel *)viewModel {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        _dataModel = viewModel;
        
        [self configSelf];
        [self configSubviews];
    }
    
    return self;
}

- (void)configSelf {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}

- (void)configSubviews {
    
    [self imageV];
    [self closeBtn];
}

- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        
        imgV.userInteractionEnabled = YES;
        imgV.layer.cornerRadius = fitToWidth(9);
        imgV.layer.masksToBounds = YES;
        [self addSubview:imgV];
        _imageV = imgV;
        
        [imgV wvr_setImageWithURL:[NSURL URLWithUTF8String:_dataModel.picUrl_]];    // placeholderImage:HOLDER_IMAGE
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imgV.superview);
            make.height.equalTo(imgV.superview);
            make.width.equalTo(imgV.superview);
        }];
    }
    return _imageV;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        WVRCircleProgressButton *btn = [[WVRCircleProgressButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-fitToWidth(65), SCREEN_HEIGHT-fitToWidth(78), fitToWidth(35), fitToWidth(35))];
        [btn setImage:[UIImage imageNamed:@"iOS_close_normal_"] forState:UIControlStateNormal];
        
        btn.trackColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        btn.progressColor = [UIColor whiteColor];
        btn.lineWidth = 2.5;
        
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _closeBtn = btn;
        
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            NSNumber *width = @(fitToWidth(18));
//            make.right.equalTo(btn.superview).offset(fitToWidth(-15));
//            make.bottom.equalTo(btn.superview).offset(fitToWidth(-45));
//            make.height.equalTo(width);
//            make.width.equalTo(width);
//        }];
    }
    return _closeBtn;
}

// MARK: - external function

- (void)show {
    
    // 先通过showRate字段判断是否符合展示条件，否则直接进入下一个流程
    switch (self.dataModel.showRate) {
            
        case WVRLaunchRecommendShowRateDaily: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypeLayer];
            long days = [NSDate getTimeDifferenceFormTimeInterval:t];
            if (days == 0) {
                [self dealForNextStep];
            } else {
                [self dealForShow];
            }
        }
            break;
            
        case WVRLaunchRecommendShowRateOnce: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypeLayer];
            if (t > 0) {
                [self dealForNextStep];
            } else {
                [self dealForShow];
            }
        }
            break;
// 在default中处理
//        case WVRLaunchRecommendShowRateEvery:
//            [self dealForShow];
//            break;
        default:
            [self dealForShow];
            break;
    }
}

- (void)dealForShow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.imageV.image) {    // 200毫秒内无法展示图片，则此次跳过本步骤，留作下次展示
            
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window endEditing:NO];
            
            [window addSubview:self];
            
            NSTimeInterval time = 5;
            [self.closeBtn startAnimationDuration:time completionBlock:^{}];
            
            [[WVRSQLiteManager sharedManager] saveADWithCode:self.dataModel.code adType:kBootAdTypeLayer];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self autoClose];
            });
        } else {
            [self dealForNextStep];
        }
    });
}

- (void)autoClose {
    if (self.superview) {
        [self removeFromSuperview];
        [self dealForNextStep];
    }
}

/// 执行下一个步骤
- (void)dealForNextStep {
    
    [[WVRLaunchFlowManager shareInstance] shouldShowNextStep];
}

// MARK: - action

- (void)closeBtnClick:(UIButton *)sender {
    
    // 关闭view，BI埋点事件
    [self removeFromSuperview];
    
    [WVRProgramBIModel trackEventForAD:[self biModel:YES]];
    
    [self dealForNextStep];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    if (touch.view == self.imageV) {
        
        CGPoint point = [touch locationInView:self];
        CGSize img_size = self.imageV.image.size;
        float y = point.y;
        float scale_height = img_size.height / (img_size.width / SCREEN_WIDTH);
        float y_valid = (SCREEN_HEIGHT - scale_height) / 2.f;
        
        BOOL valid = (y < (y_valid + scale_height)) && (y > y_valid);
        
        if (valid) {
            
            // 点击事件，并BI埋点
            
            [self removeFromSuperview];
            
            [WVRProgramBIModel trackEventForAD:[self biModel:NO]];
            [WVRGotoNextTool gotoNextVC:self.dataModel nav:[UIViewController getCurrentVC].navigationController];
            
            [self dealForNextStep];
        }
    }
}

- (WVRProgramBIModel *)biModel:(BOOL)isClose {
    WVRProgramBIModel *model = [[WVRProgramBIModel alloc] init];
    
    model.biPageId = self.dataModel.sid;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (isClose) {
        
        dict[@"eventId"] = @"close_ad";
    } else {
        dict[@"eventId"] = @"onClick_ad";
    }
    
    dict[@"pageType"] = [NSString stringWithFormat:@"%d", (int)self.dataModel.recommendAreaType];
    dict[@"showTpye"] = [NSString stringWithFormat:@"%d", (int)self.dataModel.showRate];
    
    model.otherParams = dict;
    return model;
}

@end
