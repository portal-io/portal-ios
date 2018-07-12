//
//  WVRThirtyPAuthUseCase.m
//  WhaleyVR
//
//  Created by qbshen on 2017/8/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRThirtyPAuthUseCase.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WVRErrorViewModel.h"

@implementation WVRThirtyPAuthUseCase

- (void)initRequestApi
{
    
}

- (RACSignal *)requestSignal
{
    @weakify(self);
    RACSignal *requestSignal =
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        RACSignal *successSignal = [self rac_signalForSelector:@selector(thrityPartyGetUserInfoSuccessBlock:)];
        [[successSignal map:^id(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(UMSocialUserInfoResponse* x) {
            @strongify(self);
            self.avatar = @"avatar";
            self.nickName = @"nickName";
            if (x.platformType == UMSocialPlatformType_QQ) {
                
                self.openId = x.openid;
                [WVRUserModel sharedInstance].openIdForBinding = self.openId;
                self.unionId = x.unionId;
            } else {
                
                self.openId = x.openid ?: x.uid;
                [WVRUserModel sharedInstance].openIdForBinding = x.openid ?: x.uid;
                self.unionId = x.unionId;
            }
            
            [WVRUserModel sharedInstance].wechatUnionid = x.uid;
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        RACSignal *failSignal = [self rac_signalForSelector:@selector(thrityPartyGetUserInfoFailBlock:)];
        [[failSignal map:^id(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(id x) {
            [subscriber sendError:x];
        }];

        return nil;
    }] replayLazily] takeUntil:self.rac_willDeallocSignal];
    return requestSignal;
}

-(void)thrityPartyGetUserInfoSuccessBlock:(UMSocialUserInfoResponse*)result
{
    
}

-(void)thrityPartyGetUserInfoFailBlock:(NSError*)error
{
    
}

- (RACSignal *)requestErrorSignal {
    return [self.getRequestCmd.errors subscribeOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)executionSignal {
    return [self.getRequestCmd.executionSignals switchToLatest];
}


-(RACSignal *)buildUseCase
{
    return [[self.executionSignal  map:^id _Nullable(UMSocialUserInfoResponse *  _Nullable value) {
        
        return value;
    }] doNext:^(id  _Nullable x) {
        
    }];
}

-(RACSignal *)buildErrorCase
{
    return [self.requestErrorSignal map:^id _Nullable(WVRNetworkingResponse *  _Nullable value) {
        WVRErrorViewModel *error = [[WVRErrorViewModel alloc] init];
        error.errorCode = value.content[@"code"];
        error.errorMsg = value.content[@"msg"];
        return error;
    }];
}

- (RACCommand *)getRequestCmd {
    RACCommand *requestCommand = objc_getAssociatedObject(self, @selector(requestCmd));
    if (requestCommand == nil) {
        @weakify(self);
        requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [[UMSocialManager defaultManager]  authWithPlatform:[self mappingPlatformType:self.origin] currentViewController:[WVRAppContext curViewController] completion:^(id result, NSError *error) {
//                if (error)
//                    return;
//                [[UMSocialManager defaultManager] getUserInfoWithPlatform:[self mappingPlatformType:self.origin] currentViewController:[WVRAppContext curViewController] completion:^(id result, NSError *error) {
                    @strongify(self);
                    if (error){
                        [self thrityPartyGetUserInfoFailBlock:error];
                    }else{
                        
                        [self thrityPartyGetUserInfoSuccessBlock:result];
                    }
//                }];
            }];
            return [self.requestSignal takeUntil:self.cancelthrityPAuthCmd.executionSignals];
        }];
        objc_setAssociatedObject(self, @selector(requestCmd), requestCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requestCommand;
}

- (RACCommand *)cancelthrityPAuthCmd {
    RACCommand *cancelCommand = objc_getAssociatedObject(self, @selector(cancelCmd));
    if (cancelCommand == nil) {
//        @weakify(self);
        cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            //            @strongify(self);
            //            [self cancelRequestWithRequestId:self.requestId];
            NSLog(@"cancelCommand 取消请求");
            return [RACSignal empty];
        }];
        objc_setAssociatedObject(self, @selector(cancelCmd), cancelCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cancelCommand;
}

- (UMSocialPlatformType)mappingPlatformType:(NSInteger)tag {
    
    NSDictionary* dic = @{
                          @(QQ_btn_tag): @(UMSocialPlatformType_QQ),
                          @(WX_btn_tag): @(UMSocialPlatformType_WechatSession),
                          @(WB_btn_tag): @(UMSocialPlatformType_Sina) };
    UMSocialPlatformType type = [dic[@(tag)] intValue];
    return type;
}

@end
