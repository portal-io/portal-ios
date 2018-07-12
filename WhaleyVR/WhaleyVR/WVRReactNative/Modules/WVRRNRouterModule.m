//
//  WVRRNRouterModule.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRRNRouterModule.h"
//#import "RCTBridgeModule.h"
#import "WVRBaseViewController.h"

@interface WVRRNRouterModule()<RCTBridgeModule, BaseBackForResultDelegate>

@property (nonatomic, copy) RCTPromiseResolveBlock gResolve;

@property (nonatomic, copy) RCTPromiseRejectBlock gReject;

@end


@implementation WVRRNRouterModule

RCT_EXPORT_MODULE(WVRRNRouterModule);

RCT_EXPORT_METHOD(navigation:(NSString*)className params:(NSDictionary*)params requestCode:(NSInteger)reqCode resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    Class class = NSClassFromString(className);
    
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList(class, &outCount);
    NSString * createParamName = nil;
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if([propertyName isEqualToString:@"createArgs"]){
            createParamName = propertyName;
        }
    }
    
    WVRBaseViewController* obj = [[class alloc] init];
    if (params)
        [obj setValue:params forKey:createParamName];
    self.gResolve = resolve;
    self.gReject = reject;
    obj.backDelegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       [[UIViewController getCurrentVC].navigationController pushViewController:obj animated:YES];
    });
}

-(void)backForResult:(id)info resultCode:(NSInteger)resultCode
{
    if (self.gResolve) {
        self.gResolve(nil);
    }
    
}

+(BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
