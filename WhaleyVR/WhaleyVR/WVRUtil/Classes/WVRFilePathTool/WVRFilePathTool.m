//
//  WVRFilePathTool.m
//  VRManager
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRFilePathTool.h"

@implementation WVRFilePathTool

#pragma mark - 通用

//获取沙盒Documents路径
+ (NSString *)getDocumentPath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return filePath;
}

+ (NSString *)getLibraryPath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    return filePath;
}

+ (NSString *)getCachePath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return filePath;
}

+ (NSString *)getAppDataPath {
    return [[self class] getDocumentFolderWithName:@"AppData" skipBackup:YES];
}

+ (NSString *)getFolderWithName:(NSString *)name {
    
    NSString *filePath = [[[self class] getDocumentPath] stringByAppendingPathComponent:name];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

// 注意，此方法对已存在的文件夹是无效的
+ (NSString *)getDocumentFolderWithName:(NSString *)name skipBackup:(BOOL)skipBackup {
    
    NSString *filePath = [[[self class] getDocumentPath] stringByAppendingPathComponent:name];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        // cache迁移
        NSString *cacheDir = [[[self class] getCachePath] stringByAppendingPathComponent:name];
        BOOL success = NO;
        if ([fm fileExistsAtPath:cacheDir]) {
            success = [fm moveItemAtPath:cacheDir toPath:filePath error:nil] ;
        }
        
        if (success == NO) {
            [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if (skipBackup) {
            [self addSkipBackupAttributeToItemAtPath:filePath] ;
        }
    }
    return filePath;
}

+ (BOOL)createFolderAtPath:(NSString *)path {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) { return YES; }
    
    return [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString *)getDocumentWithName:(NSString *)name {
    
    NSString *lib = [self getDocumentPath];
    if (name.length < 1) { return lib; };
    
    NSString *path = [lib stringByAppendingPathComponent:name];
    
    return path;
}

+ (NSString *)getLibraryWithName:(NSString *)name {
    
    NSString *lib = [self getLibraryPath];
    if (name.length < 1) { return lib; };
    
    NSString *path = [lib stringByAppendingPathComponent:name];
    
    return path;
}

// 允许传空
+ (NSString *)getCachesWithName:(NSString *)name {
    
    NSString *lib = [self getCachePath];
    if (name.length < 1) { return lib; };
    
    NSString *path = [lib stringByAppendingPathComponent:name];
    
    return path;
}

+ (NSString *)pathForFolder:(NSString *)folder File:(NSString *)name {
    
    return [folder stringByAppendingPathComponent:name];
}

//文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)removeFileAtPath:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"file is not exit");
        return YES;
    }
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) { NSLog(@"remove file error: %@", error.description); }
    
    return success;
}

//获取本地文件大小
+ (NSString *)getFileDataSize:(NSString *)path {
    
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:path];
    NSInteger receivedDataLength = [fileData length];
    
    return [NSString stringWithFormat:@"%ld", (long)receivedDataLength];
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString
{
    NSURL* URL= [NSURL fileURLWithPath:filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark - 数据模型的本地写入和读取

+ (NSArray *)readModelsFromFile:(NSString *)filepath {
    
    if (![[self class] fileExistsAtPath:filepath]) {
        return nil;
    }
    
    @try {
        
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        return array;
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
    
    return @[];
}

+ (void)saveModels:(NSArray *)models toFile:(NSString *)filepath {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSKeyedArchiver archiveRootObject:models toFile:filepath];
    });
}

// 更新版本时移除旧版本缓存文件，防止model更改造成闪退
+ (void)removeCachesInNewAppVersion {
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    BOOL notNewVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:appVersion] boolValue];
    if (notNewVersion) {
        return;
    }
    
    NSString *path = [self getAppDataPath];
    [self removeFileAtPath:path];       // 移除界面get请求数据缓存
    
    // warning 本代码应置于最后 其他所有判断新版本的代码都应在此之前
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:appVersion];
}

@end
