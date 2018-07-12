//
//  WVRAddressInputCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface WVRAddressInputCellInfo : SQTableViewCellInfo

@property (nonatomic) NSString * title;
@property (nonatomic) NSString * content;
@property (nonatomic) NSString * placeHolder;
@property (nonatomic) BOOL tfNotEnable;
@property (nonatomic, copy) void(^changeContentBlock)(NSString *str);

@property (nonatomic, assign) BOOL isNotMust;

@end


@interface WVRAddressInputCell : SQBaseTableViewCell

@end
