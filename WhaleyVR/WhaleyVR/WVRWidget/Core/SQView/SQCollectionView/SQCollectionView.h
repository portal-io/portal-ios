//
//  SQCollectionView.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRWidgetHeader.h"

@interface SQCollectionView : UICollectionView

- (void)updateWithSectionIndex:(NSInteger)sectionIndex;

- (void)fillData:(id)args;

@end
