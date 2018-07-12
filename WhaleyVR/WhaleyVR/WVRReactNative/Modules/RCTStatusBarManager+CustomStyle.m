//
//  RCTStatusBarManager+CustomStyle.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "RCTStatusBarManager+CustomStyle.h"
#import <objc/runtime.h>
#import "WVRBaseViewController.h"

@implementation RCTStatusBarManager (CustomStyle)
+(void)load{
    NSString*className=NSStringFromClass(self.class);
    NSLog(@"classname%@",className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        [self swizzledHidden];
        [self swizzledStyle];
    });
}

+(void)swizzledHidden
{
    Class class=[self class];
    
    //Whenswizzlingaclassmethod,usethefollowing:
    //Classclass=object_getClass((id)self);
    SEL originalSelector=@selector(setHidden:
                                   withAnimation:);
    SEL swizzledSelector=@selector(swizzledSetHidden:withAnimation:);
    
    Method originalMethod=class_getInstanceMethod(class,originalSelector);
    Method swizzledMethod=class_getInstanceMethod(class,swizzledSelector);
    
    BOOL didAddMethod=
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if(didAddMethod){
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod,swizzledMethod);
    }
}

+(void)swizzledStyle
{
    Class class=[self class];
    SEL originalSelector2=@selector(setStyle:
                                    animated:);
    SEL swizzledSelector2=@selector(swizzledSetStyle:animated:);
    
    Method originalMethod2=class_getInstanceMethod(class,originalSelector2);
    Method swizzledMethod2=class_getInstanceMethod(class,swizzledSelector2);
    
    BOOL didAddMethod2=
    class_addMethod(class,
                    originalSelector2,
                    method_getImplementation(swizzledMethod2),
                    method_getTypeEncoding(swizzledMethod2));
    
    if(didAddMethod2){
        class_replaceMethod(class,
                            swizzledSelector2,
                            method_getImplementation(originalMethod2),
                            method_getTypeEncoding(originalMethod2));
    }else{
        method_exchangeImplementations(originalMethod2,swizzledMethod2);
    }
}
-(void)swizzledSetHidden:(BOOL)hidden
           withAnimation:(UIStatusBarAnimation)animation
{
    NSLog(@"swizzledSetHidden");
    WVRBaseViewController * vc = (WVRBaseViewController*)[UIViewController getCurrentVC];
    vc.hiddenStatusBar = hidden;
    if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [vc prefersStatusBarHidden];
        [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

-(void)swizzledSetStyle:(UIStatusBarStyle)style
           animated:(BOOL)animated
{
    NSLog(@"swizzledSetStyle");
    WVRBaseViewController * vc = (WVRBaseViewController*)[UIViewController getCurrentVC];
    vc.statusBarStyle = style;
    if ([vc respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [vc preferredStatusBarStyle];
        [vc performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
@end
