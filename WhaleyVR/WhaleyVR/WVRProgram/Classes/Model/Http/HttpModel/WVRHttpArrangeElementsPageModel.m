//
//  WVRHttpArrangeElementsPage.m
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRHttpArrangeElementsPageModel.h"
@implementation WVRHttpArrangeElementsPageModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"content": WVRHttpArrangeElementModel.class};
}

@end

