//
//  WVRRouterDispatcher.m
//  WhaleyVR
//
//  Created by qbshen on 2017/4/8.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModelDispatcher.h"
#import "WVRPresenterProtocol.h"
#import "WVRViewModelProtocol.h"


@implementation WVRViewModelDispatcher

static NSMutableDictionary<NSString */*page*/, NSString */*dispatcherClazz*/>* kSections;

static NSMutableDictionary<NSString */*page*/, NSString */*dispatcherClazz*/>* kPages;

+ (void)registerSection:(NSString *)sectionID className:(NSString*)className{
    
    if (kSections == nil) {
        kSections = [[NSMutableDictionary alloc] init];
    }
    kSections[sectionID] = className;
}

+ (id)dispatchSection:(NSString *)sectionID args:(id)args {
    
    NSString *dispatcherClazz = kSections[sectionID];
    if (dispatcherClazz == nil) {
        
        NSAssert(YES, @"sectionID:%@ not register", sectionID);
    }
    Class dispatcherClass = NSClassFromString(dispatcherClazz);
    id<WVRViewModelProtocol> dispatcher = [[dispatcherClass alloc] init];
    
    return [dispatcher getSectionInfo:args];
}

+ (void)registerPage:(NSString *)pageID className:(NSString *)className {
    
    if (kPages == nil) {
        kPages = [[NSMutableDictionary alloc] init];
    }
    kPages[pageID] = className;
}

+ (id<WVRPresenterProtocol>)dispatchPage:(NSString *)pageID args:(id)args attchView:(id<WVRViewProtocol>)attchView {
    
    NSString *dispatcherClazz = kPages[pageID];
    if (dispatcherClazz == nil) {
        return nil;
    }
    Class dispatcherClass = NSClassFromString(dispatcherClazz);
    id<WVRPresenterProtocol> dispatcher = [(id<WVRPresenterProtocol>)[dispatcherClass alloc] initWithParams:args attchView:attchView];
    
    return dispatcher;
}

//- (id)dispatchWithArgs:(id)args
//{
//    NSLog(@"%@",[self class]);
//    return nil;
//}

@end
