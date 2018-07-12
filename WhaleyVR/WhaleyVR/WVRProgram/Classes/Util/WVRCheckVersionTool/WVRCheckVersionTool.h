//
//  WVRCheckVersionTool.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRAppStoreModel : NSObject

@property (nonatomic) NSString * version;
@property (nonatomic) NSString * releaseNotes;
@property (nonatomic) NSString * fileSizeBytes;

@end


@interface WVRCheckVersionTool : NSObject

+ (void)checkHaveNewVersion;

+ (void)shouldShowUpdateTip;

+ (void)gotoAppstoreForNewVersion;
/// 用户选择关闭升级提示
+ (void)cancelUpdate;

@end
