//
//  WVRSpring2018Manager.m
//  WhaleyVR
//
//  Created by Bruce on 2018/1/25.
//  Copyright © 2018年 Snailvr. All rights reserved.

// 2018新春活动管理类，之后可删除

#import "WVRSpring2018Manager.h"
#import "WVRWhaleyHTTPManager.h"
#import "WVRGotoNextTool.h"
#import "UnityAppController.h"

@interface WVRSpring2018Manager ()

@property (nonatomic, strong) UIButton *spring2018SuspendBtn;

@end


@implementation WVRSpring2018Manager

+ (instancetype)shareInstance {
    
    static WVRSpring2018Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WVRSpring2018Manager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _leftCount = -1;
        [self installRAC];
        [self registerNotification];
    }
    return self;
}

- (void)installRAC {
    
    @weakify(self);
    [[RACObserve([WVRUserModel sharedInstance], isLogined) skip:1] subscribeNext:^(id  _Nullable x) {
        if ([WVRUserModel sharedInstance].isLogined) {
            [WVRSpring2018Manager checkForSpring2018Status];
            [WVRSpring2018Manager checkForSpringLeftCount];
        } else {
            @strongify(self);
            self.leftCount = -1;
        }
    }];
}

- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)noti {
    
    [WVRSpring2018Manager checkForSpring2018Status];
    [WVRSpring2018Manager checkForSpringLeftCount];
}

/// App启动时请求接口获取新春活动信息
+ (void)checkForSpring2018Status {
    
    NSString *url = @"newVR-report-service/h5event/findEventDetail?code=springFestival2018";
    
    [WVRWhaleyHTTPManager GETService:url withParams:nil completionBlock:^(NSDictionary *responseObj, NSError *error) {
        
        NSDictionary *data = responseObj[@"data"];
        if (data) {
            
            WVRSpring2018InfoModel *model = [WVRSpring2018InfoModel yy_modelWithDictionary:data];
            [WVRSpring2018Manager shareInstance].infoModel = model;
        }
    }];
}

/// 请求剩余抽奖次数
+ (void)checkForSpringLeftCount {
    
    NSString *url = @"newVR-report-service/h5event/getLeftCount";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [WVRUserModel sharedInstance].accountId;
    params[@"token"] = [WVRUserModel sharedInstance].sessionId;
    
    [WVRWhaleyHTTPManager GETService:url withParams:params completionBlock:^(NSDictionary *responseObj, NSError *error) {
        
        NSDictionary *data = responseObj[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSNumber *count = data[@"leftCount"];
            if (count) {
                
                DDLogInfo(@"getLeftCount ----- %d", count.intValue);
                [WVRSpring2018Manager shareInstance].leftCount = count.intValue;
            }
        }
    }];
}

/// 分享渠道 qq, weixin, weibo
+ (void)reportForSharePlatform:(NSString *)platform block:(void(^)(int count))block {
    
    if (!platform.length) { return; }
    
    NSString *url = @"newVR-report-service/h5event/shareCall";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [WVRUserModel sharedInstance].accountId;
    params[@"token"] = [WVRUserModel sharedInstance].sessionId;
    params[@"channel"] = platform;
    
    [WVRWhaleyHTTPManager POSTService:url withParams:params completionBlock:^(NSDictionary *responseObj, NSError *error) {
        
        NSNumber *code = responseObj[@"code"];
        
        if (code.intValue == 200) {
            NSDictionary *data = responseObj[@"data"];
            int count = -1;
            if ([data isKindOfClass:[NSDictionary class]] && data[@"leftCount"]) {
                count = [data[@"leftCount"] intValue];
            }
            if (count >= 0) {
                [WVRSpring2018Manager shareInstance].leftCount = count;
            }
            DDLogInfo(@"新春H5分享成功，当前可抽福卡次数：%d次", [WVRSpring2018Manager shareInstance].leftCount);
        } else {
            
            DDLogError(@"spring2018 分享增加次数 请求失败！！！！");
        }
        if (block) {
            block([WVRSpring2018Manager shareInstance].leftCount);
        }
    }];
}

- (void)retryForRequest {
    
}

/// 添加新春活动首页入口
+ (void)addHomePageEntryForSpring2018 {
    
    [self checkForSpring2018Status];
    
    if ([self checkSpring2018Valid]) {
        
//        UITabBarController *tabC = (id)[UIApplication sharedApplication].windows.firstObject.rootViewController;
//        if (![tabC isKindOfClass:[UITabBarController class]]) {
//            return;
//        }
//        UINavigationController *nav = [[tabC viewControllers] firstObject];
        UIViewController *homeVC = [UIViewController getCurrentVC];//[[nav viewControllers] firstObject];
        
        UIButton *btn = [WVRSpring2018Manager shareInstance].spring2018SuspendBtn;
        btn.tag = TAG_SPRINGBTN;
        if (btn.superview && btn.superview != homeVC.view) {
            [btn removeFromSuperview];
        }
        if (!btn.superview) {
            [homeVC.view addSubview:btn];
            
//            [[[homeVC.view rac_signalForSelector:@selector(addSubview:)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
//                if (btn.superview == homeVC.view) {
//
//                    [homeVC.view bringSubviewToFront:btn];
//                }
//            }];
            
            UnityAppController *app = (id)[UIApplication sharedApplication].delegate;
            float tabbarHeight = app.tabBarController.tabBar.height;
            float bottomOffset = 0 - (tabbarHeight + fitToWidth(39));
            
            NSNumber *height = @(fitToWidth(123));
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btn.superview);
                make.bottom.equalTo(btn.superview).offset(bottomOffset);
                make.height.equalTo(height);
                make.width.equalTo(height);
            }];
        } else {
            [homeVC.view bringSubviewToFront:btn];
        }
        
    } else {
        
        UIButton *btn = [WVRSpring2018Manager shareInstance].spring2018SuspendBtn;
        
        [btn removeFromSuperview];
    }
}

- (UIButton *)spring2018SuspendBtn {
    
    if (!_spring2018SuspendBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_spring_home_entry"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(spring2018SuspendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _spring2018SuspendBtn = btn;
    }
    
    return _spring2018SuspendBtn;
}

- (void)spring2018SuspendBtnClicked:(UIButton *)sender {
    
    WVRItemModel *model = [[WVRItemModel alloc] init];
    model.linkArrangeType = LINKARRANGETYPE_H5_INNER;
    model.linkArrangeValue = self.infoModel.url;
    model.code = self.infoModel.code;
    
    [WVRGotoNextTool gotoNextVC:model nav:[UIViewController getCurrentVC].navigationController];
}

/// 检测2018新春活动是否在有效期
+ (BOOL)checkSpring2018Valid {
    [WVRSpring2018Manager shareInstance].isValid = NO;
    if (![WVRSpring2018Manager shareInstance].infoModel) {
        [self checkForSpring2018Status];
        return NO;
    }
    
    WVRSpring2018InfoModel *infoModel = [WVRSpring2018Manager shareInstance].infoModel;
    
    long time_now = infoModel.nowTime;

    if (time_now > infoModel.disableTime) {
        return NO;
    }
    if (time_now < infoModel.enableTime) {
        return NO;
    }
    [WVRSpring2018Manager shareInstance].isValid = YES;
    return YES;
}

@end


@implementation WVRSpring2018InfoModel

@end
