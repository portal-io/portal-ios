//
//  WVRNewVersionAlert.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "SQBaseView.h"

@interface WVRNewVersionAlertInfo : NSObject

@property (nonatomic) NSString * version;
@property (nonatomic) NSString * size;
@property (nonatomic) NSString * versionDesc;

@end
@interface WVRNewVersionAlert : SQBaseView
-(void)fillData:(WVRNewVersionAlertInfo*)info;
@end
