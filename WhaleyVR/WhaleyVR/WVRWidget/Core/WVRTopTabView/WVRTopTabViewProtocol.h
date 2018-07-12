//
//  WVRTopTabView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewProtocol.h"

@protocol WVRTopTabViewProtocol <WVRViewProtocol>

-(void)updateWithTitles:(NSArray*)titles andItemModels:(NSArray*)itemModels;


@end
