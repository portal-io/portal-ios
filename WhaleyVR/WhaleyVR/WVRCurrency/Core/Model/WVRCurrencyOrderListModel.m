//
//  WVRCurrencyOrderListModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/11/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCurrencyOrderListModel.h"

@implementation WVRCurrencyOrderListModel : NSObject

@end


@implementation WVRCurrencyOrderListItem : NSObject

@end


@implementation WVRCurrencyOrderListPageCache : NSObject
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"content":WVRCurrencyOrderListItem.class};
}
@end

