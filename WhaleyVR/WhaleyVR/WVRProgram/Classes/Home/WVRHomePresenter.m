//
//  WVRHomePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHomePresenter.h"
#import "WVRHomeViewControllerProtocol.h"
#import "WVRTopBarPresenter.h"
#import "WVRHomePagePresenter.h"

#define HOME_PAGE_REQUEST_PARAM (@"Page_Recommend")

@interface WVRHomePresenter ()

@property (nonatomic, weak) id<WVRHomeViewControllerProtocol> gView;

@end


@implementation WVRHomePresenter
@synthesize gTopBarPresenter = _gTopBarPresenter;
@synthesize gPagePresenter = _gPagePresenter;

- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view
{
    self = [super init];
    if (self) {
        if ([view conformsToProtocol:@protocol(WVRHomeViewControllerProtocol)]) {
            self.gView = (id<WVRHomeViewControllerProtocol>)view;
        }else{
            NSException *exception = [[NSException alloc] initWithName:[self description] reason:@"view not conformsTo WVRViewProtocol" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)fetchData
{
    [self requestInfo];
}

- (void)requestInfo
{
    [self.gTopBarPresenter requestInfo:HOME_PAGE_REQUEST_PARAM];
}

- (WVRTopBarPresenter *)gTopBarPresenter
{
    if (!_gTopBarPresenter) {
        _gTopBarPresenter = [[WVRTopBarPresenter alloc] initWithParams:HOME_PAGE_REQUEST_PARAM attchView:self.gView];
    }
    return _gTopBarPresenter;
}

- (WVRHomePagePresenter *)gPagePresenter
{
    if (!_gPagePresenter) {
        _gPagePresenter = [[WVRHomePagePresenter alloc] initWithParams:nil attchView:self.gView];
//       _gPagePresenter.viewController = (UIViewController*)self.gView;
    }
    return _gPagePresenter;
}

@end
