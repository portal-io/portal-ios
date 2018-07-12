//
//  WVRHttpHistoryListModel.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpHistoryListModel.h"

@implementation WVRHttpHistoryListModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"content": WVRHttpHistoryItemModel.class};
}
@end
@implementation WVRHttpHistoryItemModel

@end
