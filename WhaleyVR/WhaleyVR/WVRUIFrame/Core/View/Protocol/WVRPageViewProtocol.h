//
//  WVRPageViewPresenter.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewProtocol.h"

@protocol WVRPageViewProtocol <WVRViewProtocol>

-(void)reloadData;
-(void)scrollingToPageNamber:(NSInteger)index;

-(void)scrolling:(CGFloat)scale flag:(BOOL)bigFlag;

-(void)scrollToPageNamber:(NSInteger)index;//

-(void)scrollViewDidEndDecelerating:(NSUInteger)index;

@end
