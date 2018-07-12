//
//  WVRFilePathTool.h
//  VRManager
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WVRDefine.h"

@interface WVRFilePathTool : NSObject

#pragma mark - 通用

+ (NSString *)getAppDataPath;
+ (BOOL)createFolderAtPath:(NSString *)path;

// Documents
+ (NSString *)getFolderWithName:(NSString *)name;

+ (NSString *)getDocumentFolderWithName:(NSString *)name skipBackup:(BOOL)skipBackup ;

+ (NSString *)getDocumentWithName:(NSString *)name;
+ (NSString *)getLibraryWithName:(NSString *)name;
+ (NSString *)getCachesWithName:(NSString *)name;

/**
 *  文件是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 *  移除文件
 */
+ (BOOL)removeFileAtPath:(NSString *)path;

/**
 *  获取本地文件大小
 */
+ (NSString *)getFileDataSize:(NSString *)path;

#pragma mark - 数据模型的本地写入和读取

+ (NSArray *)readModelsFromFile:(NSString *)filepath;

+ (void)saveModels:(NSArray *)models toFile:(NSString *)filepath;


// 更新版本时移除旧版本缓存文件，防止model更改造成闪退
+ (void)removeCachesInNewAppVersion;

@end
