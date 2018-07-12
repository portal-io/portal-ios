//
//  WVRHomePageCollectionView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/7/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseCollectionView.h"
#import "WVRCollectionViewProtocol.h"

@interface WVRHomePageCollectionView : WVRBaseCollectionView<WVRCollectionViewProtocol>

- (void)updateWithSectionIndex:(NSInteger)sectionIndex;

- (void)fillData:(id)args;

@end
