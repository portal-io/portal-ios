//
//  WVRLiveRecReuHeader.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/15.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecTitleHeader.h"

@interface WVRLiveRecTitleHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;


@end
@implementation WVRLiveRecTitleHeader

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    WVRLiveRecTitleHeaderInfo * headerInfo = (WVRLiveRecTitleHeaderInfo *)info;
    self.titleL.text = headerInfo.title;
}

@end
@implementation WVRLiveRecTitleHeaderInfo

@end
