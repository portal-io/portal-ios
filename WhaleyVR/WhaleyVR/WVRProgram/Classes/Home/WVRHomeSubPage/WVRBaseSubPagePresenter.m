//
//  WVRBasePagePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseSubPagePresenter.h"
#import "WVRViewModelDispatcher.h"

#import "WVRSectionModel.h"
#import "WVRBaseCollectionView.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "WVRBaseViewSection.h"

@interface WVRBaseSubPagePresenter ()


@end

@implementation WVRBaseSubPagePresenter


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithParams:(id)params attchView:(id<WVRViewProtocol>)view {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)fetchData
{

}

-(void) addFooter
{
    if (self.collectionView.mj_footer) {
        return;
    }
    kWeakSelf(self);
    SQRefreshFooter * refreshFooter = [SQRefreshFooter footerWithRefreshingBlock:^{
        
        [weakself footerMoreRequestInfo:nil];
    }];
    self.collectionView.mj_footer = refreshFooter;
}

- (void)requestInfo:(id)requestParams {
    

}

- (void)requestInfoForFirst:(id)requestParams {
    
    
}

- (void) headerRefreshRequestInfo:(id)requestParams {
    

}

- (void)reloadPlayer {
    
    
}

- (void)footerMoreRequestInfo:(id)requestParams {
    

}

- (WVRBaseViewSection *)sectionInfo:(WVRSectionModel *)sectionModel {
    
    //    NSLog(@"recommendAreaType:%ld", (long)sectionModel.sectionType);
    WVRBaseViewSection * sectionInfo = nil;
    NSInteger type = sectionModel.sectionType;
    sectionInfo = [WVRViewModelDispatcher dispatchSection:[NSString stringWithFormat:@"%d", (int)type] args:sectionModel];//[self getADSectionInfo:sectionModel type:type];
    [sectionInfo registerNibForCollectionView:self.collectionView];
//    sectionInfo.viewController = self.viewController;
    return sectionInfo;
}

- (void)networkFaild
{
    [self.gView showToast:kNoNetAlert];
}
@end
