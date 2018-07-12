//
//  WVRAddressPickerV.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNLoadPlaceTool.h"

@interface WVRAddressPickerVInfo : NSObject

@property (nonatomic) NSArray<SNBasePlaceInfo*> *pickDataArr;
@property (nonatomic, copy) void(^completeBlock)(SNBasePlaceInfo *info);

@end


@interface WVRAddressPickerV : UIView

- (void)fillData:(WVRAddressPickerVInfo *)info;
- (void)reloadData;

@end
