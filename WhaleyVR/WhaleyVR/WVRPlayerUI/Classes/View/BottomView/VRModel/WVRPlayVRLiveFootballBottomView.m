//
//  WVRPlayVRLiveFootballBottomView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayVRLiveFootballBottomView.h"
#import "WVRCameraChangeButton.h"
#import "WVRPlayerUIFrameMacro.h"
#import "UIImage+Extend.h"
#import "WVRPlayerViewDelegate.h"

@interface WVRPlayVRLiveFootballBottomView()

@property (nonatomic, strong) NSDate *lastSendDate;

@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRPlayVRLiveFootballBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)fillData:(WVRPlayBottomCellViewModel *)args {
    self.gViewModel = args;
    [self installRAC];
    [self resetCameraStandBtn];
}

- (void)installRAC {
    [super installRAC];
    @weakify(self);
    [[RACObserve(((WVRPlayBottomCellViewModel*)self.gViewModel), defiTitle) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *title = x;
        if (title.length == 0) { return; }
        [self.defiButton setTitle:x forState:UIControlStateNormal];
    }];

}

- (void)cameraBtnClick:(UIButton *)sender {
    
    if (self.cameraStandBtns) {
        
        [self removeCameraStandBtns];
        
    } else {
        
        NSArray *arr = nil;
        if ([self.gViewModel.delegate respondsToSelector:@selector(actionGetCameraStandList)]) {
            id<WVRPlayerViewDelegate> delegate = (id<WVRPlayerViewDelegate>)self.gViewModel.delegate;
            arr = [delegate actionGetCameraStandList];
        }
        
        NSMutableArray *btnArr = [NSMutableArray array];
        
        int j = (int)arr.count;
        for (NSDictionary *dict in arr) {
            
            WVRCameraChangeButton *btn = [[WVRCameraChangeButton alloc] init];
            
            btn.x = sender.x;
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

- (void)resetCameraStandBtn
{
    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = NO;
    }
    WVRCameraChangeButton *btn = [_cameraStandBtns firstObject];
    btn.isSelect = YES;
}

- (void)removeCameraStandBtns {
    for (UIButton *btn in _cameraStandBtns) {
        [btn removeFromSuperview];
    }
    _cameraStandBtns = nil;
}

- (void)updateCamerabtnForFootball {
    
    float width = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = self.width < width;
}

- (NSString *)cameraPoint {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    
    CGPoint point = [self convertPoint:_cameraBtn.center toView:window];
    
    return NSStringFromCGPoint(point);
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

//- (IBAction)backOnClick:(id)sender {
//    if ([self.gViewModel.delegate respondsToSelector:@selector(backOnClick:)]) {
//        [self.gViewModel.delegate backOnClick:sender];
//    }
//}
//- (IBAction)vrModeBtnOnClick:(id)sender {
//    if ([self.gViewModel.delegate respondsToSelector:@selector(launchOnClick:)]) {
//        [self.gViewModel.delegate launchOnClick:nil];
//    }
//}
//- (IBAction)defiBtnOnClick:(id)sender {
//    if ([self.gViewModel.delegate respondsToSelector:@selector(chooseQuality)]) {
//        [self.gViewModel.delegate chooseQuality];
//    }
//}
- (IBAction)cameraBtnOnClick:(id)sender {
    [self cameraBtnClick:sender];
}

- (void)updateStatus:(WVRPlayerToolVStatus)status {
    [super updateStatus:status];
    
//    switch (status) {
//        case WVRPlayerToolVStatusDefault:
//            [self enableDefaultStatus];
//            break;
//        case WVRPlayerToolVStatusPrepared:
//            [self enablePrepareStatus];
//            break;
//        case WVRPlayerToolVStatusPlaying:
//            [self enablePlayingStatus];
//            break;
//        case WVRPlayerToolVStatusPause:
//        case WVRPlayerToolVStatusUserPause:
//            [self enablePauseStatus];
//            break;
//        case WVRPlayerToolVStatusStop:
//            [self enableStopStatus];
//            break;
//        case WVRPlayerToolVStatusComplete:
//            [self enableCompleteStatus];
//            break;
//        case WVRPlayerToolVStatusError:
//            [self enableErrorStatus];
//            break;
//        case WVRPlayerToolVStatusChangeQuality:
//            [self enableChangeQuStatus];
//            break;
//        case WVRPlayerToolVStatusSliding:
//
//            break;
//        default:
//            break;
//    }
}

//- (void)enableNotClockStatus {
//    self.hidden = NO;
// 
//}
//
//- (void)enableDefaultStatus {
//    
//    self.defiButton.userInteractionEnabled = NO;
//}
//
//- (void)enablePrepareStatus {
//    
//}
//
//- (void)enablePlayingStatus {
//    
//    self.defiButton.userInteractionEnabled = YES;
//}
//
//- (void)enablePauseStatus {
//
//}
//
//- (void)enableStopStatus {
//    
//}
//
//- (void)enableCompleteStatus {
//    
//}
//
//- (void)enableErrorStatus {
//    
//}
//
//- (void)enableChangeQuStatus {
//    
//    
//    self.defiButton.userInteractionEnabled = NO;
//    
//}
//
//- (void)enableHidenStatus {
//    
//    self.hidden = YES;
//}
//
//- (void)enableShowStatus {
//    
//    self.hidden = NO;
//}

@end
