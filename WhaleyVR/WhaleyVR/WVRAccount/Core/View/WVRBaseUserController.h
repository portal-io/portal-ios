//
//  WVRBaseUserController.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseViewController.h"

@interface WVRLoginVCThirdpartyModel : NSObject

@property (nonatomic) id data;
@property (nonatomic) NSString * avatar;
@property (nonatomic) NSString * thirdOrigin;
@property (nonatomic) NSString * nickName;

@end


@interface WVRBaseUserController : WVRBaseViewController

@property (nonatomic, copy) void(^loginSuccessBlock)(void);
@property (nonatomic, copy) void(^cancelBlock)(void);

- (void)httpLoginSuccess;
//- (void)httpOtherLoginSuccessBlock:(WVRLoginVCThirdpartyModel *)model avatar:(NSString *)avatar;
- (void)gotoPerfectInfoVC;

@end
