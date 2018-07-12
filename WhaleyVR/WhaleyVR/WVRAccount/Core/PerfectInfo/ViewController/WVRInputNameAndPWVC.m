//
//  WVRInputNameAndPWVC.m
//  WhaleyVR
//
//  Created by qbshen on 16/10/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRInputNameAndPWVC.h"
#import "WVRUserModel.h"
#import "WVRInputNameAndPWViewModel.h"

@interface WVRInputNameAndPWVC ()

@property (nonatomic, strong) WVRInputNameAndPWViewModel * gInputNamePWViewModel;

@end
@implementation WVRInputNameAndPWVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

-(void)setUp
{
    @weakify(self);
    [self.gInputNamePWViewModel.completeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self httpFinishNamePWSuccessBlock:nil];
    }];
}

-(WVRInputNameAndPWViewModel *)gInputNamePWViewModel
{
    if (!_gInputNamePWViewModel) {
        _gInputNamePWViewModel = [[WVRInputNameAndPWViewModel alloc] init];
    }
    return _gInputNamePWViewModel;
}

-(void)loginBtnOnClickInputNameAndPD
{
    NSString *nickName = [self.contentView getNickname];
    NSString *password = [self.contentView getPassword];
    [[self keyTool] hideKeyboard];
    if ([WVRGlobalUtil isEmpty:nickName])
    {
        SQToastBottom(@"请输入昵称");
        return;
    }
    NSInteger totalNum = [self unicodeLengthOfString:nickName];
    if (totalNum < 3 || totalNum > 30) {
        SQToastBottom(@"昵称格式不正确");
        return;
    }
    if(password.length == 0){
        SQToastBottom(@"请输入密码");
        return;
    }
    if (![WVRGlobalUtil validatePassword:password])
    {
        SQToastBottom(@"密码格式不对");
        return;
    }
    self.gInputNamePWViewModel.nickName = [self.contentView getNickname];
    self.gInputNamePWViewModel.password = [self.contentView getPassword];
    [[self.gInputNamePWViewModel finishNamePWCmd] execute:nil];
//    [self httpFinishNamePW];
}

//按照中文两个字符，英文数字一个字符计算字符数
-(NSUInteger) unicodeLengthOfString:(NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 3;
    }
    return asciiLength;
}

//#pragma http user
//-(void)httpFinishNamePW{
//    NSString *deviceId = [WVRUserModel sharedInstance].deviceId;
//    NSString *nickName = [self.contentView getNickname];
//    NSString *password = [self.contentView getPassword];
//    WVRHttpFinishNamePW * cmd = [[WVRHttpFinishNamePW alloc] init];
//    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
//    httpDic[kHttpParams_finishNamePW_nickname] = nickName;
//    httpDic[kHttpParams_finishNamePW_password] = password;
//    httpDic[kHttpParams_finishNamePW_accesstoken] = [WVRUserModel sharedInstance].sessionId;
//    httpDic[kHttpParams_finishNamePW_device_id] = deviceId;
//
//    cmd.bodyParams = httpDic;
//    cmd.successedBlock = ^(id data) {
//        [self httpFinishNamePWSuccessBlock:data];
//    };
//    cmd.failedBlock = ^(NSString* errMsg){
//        NSLog(@"fail msg: %@",errMsg);
//        [self requestFaild:errMsg];
//    };
//    [cmd loadData];
//}

-(void)httpFinishNamePWSuccessBlock:(id)data
{
    [self httpLoginSuccess];
}
@end
