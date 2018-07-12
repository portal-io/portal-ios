//
//  WVRRewardHeaderV.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/10.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRRewardHeaderVInfo : NSObject

@property (nonatomic) NSString * address;
@property (nonatomic) NSString * operateTitle;

@property (nonatomic,copy) void(^changeBlock)(void);
@end
@interface WVRRewardHeaderV : UIView
-(void)fillData:(WVRRewardHeaderVInfo*)info;
@end
