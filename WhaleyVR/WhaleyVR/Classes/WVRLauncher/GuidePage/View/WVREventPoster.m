//
//  WVREventPoster.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/19.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 活动海报图

#import "WVREventPoster.h"
#import "WVRGotoNextTool.h"
#import "WVRProgramBIModel.h"
#import "WVRSQLiteManager.h"
#import "WVRLaunchFlowManager.h"

@interface WVREventPoster ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UIButton *closeBtn;

//@property (nonatomic, weak) UIVisualEffectView *effectView;

@property (nonatomic, weak) UIImageView *bgImgV;

@property (nonatomic, strong) WVRRecommendItemModel *dataModel;

@end


@implementation WVREventPoster

- (instancetype)initWithModel:(WVRRecommendItemModel *)viewModel {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        _dataModel = viewModel;
        
        [self configSubviews];
    }
    
    return self;
}

- (void)configSubviews {
    
//    [self effectView];
    [self bgImgV];
    [self imageV];
    [self closeBtn];
}

- (UIImageView *)bgImgV {
    if (!_bgImgV) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_ad_poster"]];
        imgV.frame = self.bounds;

        [self addSubview:imgV];
        _bgImgV = imgV;
    }
    return _bgImgV;
}

//- (UIVisualEffectView *)effectView {
//
//    if (!_effectView) {
//
//        //实现模糊效果
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        //毛玻璃视图
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = self.bounds;
//
//        [self addSubview:effectView];
//        _effectView = effectView;
//    }
//
//    return _effectView;
//}

- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imgV = [[UIImageView alloc] init];
        
        imgV.userInteractionEnabled = YES;
        imgV.layer.cornerRadius = fitToWidth(9);
        imgV.layer.masksToBounds = YES;
        [self addSubview:imgV];
        _imageV = imgV;
        
        [imgV wvr_setImageWithURL:[NSURL URLWithUTF8String:_dataModel.picUrl_]];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imgV.superview);
            make.height.equalTo(@(fitToWidth(400)));
            make.width.equalTo(@(fitToWidth(300)));
        }];
    }
    return _imageV;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"iOS_close_normal_"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _closeBtn = btn;
        
        NSNumber *width = @(fitToWidth(18));
        
        kWeakSelf(self);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(btn.superview);
            make.top.equalTo(weakself.imageV.mas_bottom).offset(fitToWidth(45));
            make.height.equalTo(width);
            make.width.equalTo(width);
        }];
    }
    return _closeBtn;
}

// MARK: - external function

- (void)show {
    
    // 先通过showRate字段判断是否符合展示条件，否则直接进入下一个流程
    switch (self.dataModel.showRate) {
            
        case WVRLaunchRecommendShowRateDaily: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypePoster];
            long days = [NSDate getTimeDifferenceFormTimeInterval:t];
            if (days == 0) {
                [self dealForNextStep];
            } else {
                [self dealForShow];
            }
        }
            break;
            
        case WVRLaunchRecommendShowRateOnce: {
            
            NSTimeInterval t = [[WVRSQLiteManager sharedManager] lastShowTimeForADCode:self.dataModel.code adType:kBootAdTypePoster];
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
            
            [[WVRSQLiteManager sharedManager] saveADWithCode:self.dataModel.code adType:kBootAdTypePoster];
        } else {
            [self dealForNextStep];
        }
    });
}

/// 执行下一个步骤
- (void)dealForNextStep {
    
    [[WVRLaunchFlowManager shareInstance] dealWithUpdateVersion];
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
        // 点击事件，并BI埋点
        
        [self removeFromSuperview];
        
        UIViewController *vc = [UIViewController getCurrentVC];
        UINavigationController *nav = vc.navigationController;
        NSInteger count = nav.viewControllers.count;
        
        [WVRProgramBIModel trackEventForAD:[self biModel:NO]];
        [WVRGotoNextTool gotoNextVC:self.dataModel nav:nav];
        
        if (count == nav.viewControllers.count) {
            // 跳转失败或者并没有触发跳转
            
            [self dealForNextStep];
        } else {
            
            [[[vc rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
                
                [[WVRLaunchFlowManager shareInstance] dealWithUpdateVersion];
            }];
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
