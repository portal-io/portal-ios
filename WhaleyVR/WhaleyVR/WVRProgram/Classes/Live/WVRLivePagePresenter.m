//
//  WVRLivePagePresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLivePagePresenter.h"

@implementation WVRLivePagePresenter

-(WVRBaseSubPagePresenter*)getSubPagePresenterWithModel:(WVRItemModel*)param andView:(WVRHomePageCollectionView*)collectionView
{
    WVRBaseSubPagePresenter* presenter = (id<WVRBaseSubPagePresenterProtocol>)[WVRViewModelDispatcher dispatchPage:[NSString stringWithFormat:@"%d%@",(int)param.linkType_,param.linkArrangeType] args:param attchView:collectionView];
    return presenter;
}


@end
