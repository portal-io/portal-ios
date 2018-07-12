//
//  WVRFindPagePresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPresenterProtocol.h"
#import "WVRBaseSubPagePresenter.h"
#import "WVRHomePageCollectionView.h"

@protocol WVRHomePagePresenterProtocol <WVRPresenterProtocol>

-(WVRBaseSubPagePresenter*)getSubPagePresenterWithModel:(WVRItemModel*)param andView:(WVRHomePageCollectionView*)collectionView;

@end
