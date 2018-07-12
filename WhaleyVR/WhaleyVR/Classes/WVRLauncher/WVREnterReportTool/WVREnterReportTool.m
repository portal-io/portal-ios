//
//  WVREnterReportTool.m
//  WhaleyVR
//
//  Created by qbshen on 2016/11/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVREnterReportTool.h"
#import "WVRAppEnterReportUseCase.h"
#import "WVRAppEnterReport2UseCase.h"

@interface WVREnterReportTool ()

@property (nonatomic, strong) WVRAppEnterReportUseCase * gAppEnterReportUC;
@property (nonatomic, strong) WVRAppEnterReport2UseCase * gAppEnterReport2UC;

@end
@implementation WVREnterReportTool

+ (void)startReport
{
    WVREnterReportTool * tool= [[WVREnterReportTool alloc] init];
    [tool installRAC];
    [tool reportOneStep];
}

-(WVRAppEnterReportUseCase *)gAppEnterReportUC
{
    if (!_gAppEnterReportUC) {
        _gAppEnterReportUC = [[WVRAppEnterReportUseCase alloc] init];
    }
    return _gAppEnterReportUC;
}

-(WVRAppEnterReport2UseCase *)gAppEnterReport2UC
{
    if (!_gAppEnterReport2UC) {
        _gAppEnterReport2UC = [[WVRAppEnterReport2UseCase alloc] init];
    }
    return _gAppEnterReport2UC;
}

-(void)installRAC
{
    @weakify(self);
    [[self.gAppEnterReportUC buildUseCase] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reportTwoSetp];
        NSLog(@"reportOne success");
    }];
    [[self.gAppEnterReportUC buildErrorCase] subscribeNext:^(id  _Nullable x) {
         NSLog(@"fail msg: %@",x);
    }];
    [[self.gAppEnterReport2UC buildUseCase] subscribeNext:^(id  _Nullable x) {
        NSLog(@"reportTwo success");
        [[WVRUserModel sharedInstance] setIsReport:YES];
    }];
    [[self.gAppEnterReport2UC buildErrorCase] subscribeNext:^(id  _Nullable x) {
        NSLog(@"fail msg: %@",x);
    }];
}

- (void)reportOneStep {

    [[self.gAppEnterReportUC getRequestCmd] execute:nil];
}


- (void)reportTwoSetp
{

    [[self.gAppEnterReport2UC getRequestCmd] execute:nil];

}

@end
