//
//  WVRLiveTopBarPresenter.m
//  WhaleyVR
//
//  Created by qbshen on 2017/10/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTopBarPresenter.h"

@implementation WVRLiveTopBarPresenter
-(void)filterModelType:(NSArray*)originModels
{
    for (WVRItemModel * cur in originModels) {
       if ([cur.linkArrangeType isEqualToString:LINKARRANGETYPE_LIVEORDERLIST])
       {
            [self.mItemModels addObject:cur];
       }else if ([cur.linkArrangeType isEqualToString:LINKARRANGETYPE_RECOMMENDPAGE]) {
            if ([cur.recommendPageType isEqualToString:RECOMMENDPAGETYPE_MIX]) {
                [self.mItemModels addObject:cur];
            }else if ([cur.recommendPageType isEqualToString:RECOMMENDPAGETYPE_PAGE]) {
                [self.mItemModels addObject:cur];
            }
        }else if ([cur.linkArrangeType isEqualToString:LINKARRANGETYPE_FOOTBALLLIST]) {
            [self.mItemModels addObject:cur];
        }else if ([cur.linkArrangeType isEqualToString:LINKARRANGETYPE_FOOTBALLLIST]) {
            [self.mItemModels addObject:cur];
        }
//        switch (cur.linkType_) {
//            case WVRLinkTypeMix:
//                [self.mItemModels addObject:cur];
//                break;
//            case WVRLinkTypeList:
//                [self.mItemModels addObject:cur];
//                break;
//            case WVRLinkTypePage:
//                [self.mItemModels addObject:cur];
//                break;
//                //            case WVRLinkTypeTitle:
//                //                [self.mItemModels addObject:cur];
//                //                break;
//            default:
//                break;
//        }
    }
}
@end
