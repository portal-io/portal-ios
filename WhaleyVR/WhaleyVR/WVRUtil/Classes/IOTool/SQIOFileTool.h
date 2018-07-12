//
//  DTPIOFileTool.h
//  DTPocket
//
//  Created by sqb on 15/3/27.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQIOFileTool : NSObject

+ (NSNumber *)freeDiskSpace;
+ (BOOL)writeToFile:(NSString*)filePath withData:(NSData*)fileData;
+ (NSDictionary*)readFromFile:(NSString*)filePath;
+ (NSString *) freeDiskSpaceInBytes;//手机剩余空间
+ (long long) freeDiskSpaceFormatBytes;
+ (long long) freeDiskSpaceFormatMB;
+ (NSString *) totalDiskSpaceInBytes;//手机总空间
+ (NSString *) folderSizeAtPath:(NSString*) folderPath;//某个文件夹占用空间的大小

@end
