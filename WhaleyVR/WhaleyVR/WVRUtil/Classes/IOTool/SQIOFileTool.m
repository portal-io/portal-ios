//
//  DTPIOFileTool.m
//  DTPocket
//
//  Created by sqb on 15/3/27.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SQIOFileTool.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation SQIOFileTool



+ (BOOL)writeToFile:(NSString*)filePath withData:(NSData*)fileData
{
//    NSData * fileData = [@"Some sample data" dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* fileName = [filePath stringByAppendingPathComponent:@"text_1.txt"];
    return [fileData writeToFile:filePath atomically:YES];

}

+ (NSDictionary*)readFromFile:(NSString*)filePath
{
    NSError *error;
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    if (!fileData) {
        return nil;
    }
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    return weatherDic;
}

//手机剩余空间
+ (NSString *) freeDiskSpaceInBytes {
    struct statfs buf;
    long long freespace = -1;
    if (statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    return [self humanReadableStringFromBytes:freespace];
}

+ (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (long long) freeDiskSpaceFormatBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
    
}
//手机剩余空间
+ (long long) freeDiskSpaceFormatMB{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace/1024/1024;
    
}
//手机总空间
+ (NSString *) totalDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = 0;
    if (statfs("/", &buf) >= 0) {
        freespace = (long long)buf.f_bsize * buf.f_blocks;
    }
    if (statfs("/private/var", &buf) >= 0) {
        freespace += (long long)buf.f_bsize * buf.f_blocks;
    }
    printf("%lld\n",freespace);
    return [self humanReadableStringFromBytes:freespace];
}

//遍历文件夹获得文件夹大小
+ (NSString *) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return [self humanReadableStringFromBytes:folderSize];
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//计算文件大小
+ (NSString *)humanReadableStringFromBytes:(unsigned long long)byteCount
{
    float numberOfBytes = byteCount;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB",@"EB",@"ZB",@"YB",nil];
    
    while (numberOfBytes > 1024) {
        numberOfBytes /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",numberOfBytes, [tokens objectAtIndex:multiplyFactor]];
}

-(void)other:(NSString*)filePath
{
    //    NSString* fileName = [filePath stringByAppendingPathComponent:@"text_1.txt"];
    //    NSString* myString = [NSString stringWithContentsOfFile:filePath usedEncoding:NULL error:NULL];
    //    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    //    NSString * str = [weatherDic valueForKey:@"firstName"];
    //    UIImage * image = [UIImage imageNamed:@"30adcbef76094b368d5c7c19a1cc7cd98c109d73.jpg"];
    //    NSData * data = UIImageJPEGRepresentation(image, 1);
    //    NSString* jpgName = [filePath stringByAppendingPathComponent:@"text_1.jpg"];
    //    [data writeToFile:jpgName atomically:YES];
    //    UIImage * imagePng = [UIImage imageNamed:@"2cf5e0fe9925bc31e5d8ea9e5ddf8db1cb13702b.png"];
    //    NSData * dataPng = UIImagePNGRepresentation(imagePng);
    //    NSString* pngName = [filePath stringByAppendingPathComponent:@"text_2.png"];
    //    [dataPng writeToFile:pngName atomically:YES];
    
}

@end
