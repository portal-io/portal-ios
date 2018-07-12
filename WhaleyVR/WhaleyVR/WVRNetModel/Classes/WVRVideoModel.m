//
//  WVRVideoModel.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRVideoModel.h"
#import <LKDBHelper.h>
#import "WVRCocoaHttpServerHeader.h"

@implementation WVRVideoModel

- (NSString *)uuid
{
    if (!_uuid) {
        _uuid = [[NSUUID UUID] UUIDString];;
    }
    return _uuid;
}

- (BOOL)save
{
    LKDBHelper* globalHelper = [WVRVideoModel getUsingLKDBHelper];
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    self.createTime = a;
    NSString * itemId = self.itemId;
    NSString * where = [NSString stringWithFormat:@"itemId=%@%@%@", @"'", itemId, @"'"];
    NSMutableArray* arraySync = [WVRVideoModel searchWithWhere: where orderBy:nil offset:0 count:1];
    if (arraySync.count > 0) {
        WVRVideoModel * dbModel = [arraySync firstObject];
        [self updateModel:dbModel];
        return [globalHelper updateToDB:dbModel where:nil];
    } else
    {
        return [globalHelper insertToDB:self];
//        [globalHelper insertToDB:self callback:^(BOOL isInsert) {
//            NSLog(@"insert over");
//            return isInsert;
//        }];
    }
}

- (void)updateModel:(WVRVideoModel *)dbModel
{
    dbModel.name = self.name;
    dbModel.thubImage = self.thubImage;
    dbModel.intrDesc = self.intrDesc;
    dbModel.subTitle = self.subTitle;
    dbModel.downProgress = self.downProgress;
//    if (dbModel.pathToFile) {
//        dbModel.pathToFile = self.pathToFile;
//    }
    if (self.totalSize > 0) {
        dbModel.totalSize = self.totalSize;
    }
    dbModel.curSize = self.curSize;
    dbModel.isDownload = self.isDownload;
    dbModel.downloadOver = self.downloadOver;
    if (self.downLink) {
        dbModel.downLink = self.downLink;
    }
    if (self.localUrl) {
        dbModel.localUrl = self.localUrl;
    }
    dbModel.downStatus = self.downStatus;
    dbModel.renderType = self.renderType;
    dbModel.duration = self.duration;
    dbModel.definition = self.definition;
    dbModel.renderTypeStr = self.renderTypeStr;
}

+ (WVRVideoModel *)loadFromDBWithId:(NSString *)itemId
{
    NSString * where = [NSString stringWithFormat:@"itemId=%@%@%@", @"'", itemId, @"'"];
    NSMutableArray* arraySync = [WVRVideoModel searchWithWhere: where orderBy:nil offset:0 count:1];
    WVRVideoModel * dbModel = nil;
    if (arraySync.count > 0)
        dbModel = [arraySync firstObject];
    return dbModel;
}

+ (NSArray *)searchAllFromDBWithDownFlag:(BOOL)downFlag
{
    NSString * where = [NSString stringWithFormat:@"isDownload=%@%d%@", @"'", downFlag, @"'"];
//    NSString * orderBy = [NSString stringWithFormat:@"createTime DESC"];
    NSMutableArray* arraySync = [WVRVideoModel searchWithWhere: where orderBy:nil offset:0 count:1000];
    
    return arraySync;
}

- (void)deleteWithItemId:(NSString *)itemId
{
    NSString * where = [NSString stringWithFormat:@"itemId=%@%@%@", @"'", itemId, @"'"];
    NSMutableArray* arraySync = [WVRVideoModel searchWithWhere: where orderBy:nil offset:0 count:1];
    WVRVideoModel * dbModel = nil;
    if (arraySync.count > 0)
        dbModel = [arraySync firstObject];
    if(dbModel)
        [dbModel deleteToDB];
    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString pathWithComponents:@[SQCocoaHttpServerRoot, dbModel.itemId]] error:&error];
    NSLog(@"del file error: %@", error.description);
}

- (NSString *)pathToFile
{
    NSString * filePath = [self pathToDL:self];
    return filePath;
}

- (NSString*)pathToDL:(WVRVideoModel *)videoModel
{
    if (videoModel.itemId.length == 0) {
        return nil;
    }
    NSString * path = [NSString pathWithComponents:@[SQCocoaHttpServerRoot,videoModel.itemId]];
    NSString * fileName = [[[[videoModel.downLink componentsSeparatedByString:@"?"] firstObject] componentsSeparatedByString:@"/"] lastObject];
    videoModel.pathToFile = [NSString stringWithFormat:@"%@", path];
    videoModel.fileName = fileName;
//    if (!videoModel.localUrl) {
        NSString * url = [self createLocalM3U8file:videoModel.itemId fileName:[[fileName componentsSeparatedByString:@"."] firstObject] duration:videoModel.duration];
        if (url) {
            videoModel.localUrl = url;
        }else{
            return nil;
        }
//    }else{
//        DebugLog(@"该视频本地文件路径已存在");
//    }
    return path;
}

- (NSString*)createLocalM3U8file:(NSString*)fileId fileName:(NSString*)fileName duration:(NSInteger)duration
{
    if (!fileName) {
        return nil;
    }
    NSString *downloadDic = SQCocoaHttpServerRoot;
    NSString *saveTo = [downloadDic stringByAppendingPathComponent:fileId];
    NSString *fullpath = [saveTo stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.m3u8", fileName]];
    DebugLog(@"createLocalM3U8file:%@", fullpath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:saveTo]) {
        /** 创建 */
        NSError *error2;
        BOOL createSuc2 = [[NSFileManager defaultManager] createDirectoryAtPath:saveTo withIntermediateDirectories:YES attributes:nil error:&error2];
        if (!createSuc2) {
            DebugLog(@"创建失败:%@", error2);
            return nil;
        }
    }else{
        DebugLog(@"路径已存在，不需要创建");
    }
    
    //创建文件头部
    NSString* head = [NSString stringWithFormat:@"#EXTM3U\n#EXT-X-TARGETDURATION:%ld\n#EXT-X-VERSION:2\n#EXT-X-DISCONTINUITY\n", (long)duration];
    
    NSString* segmentPrefix = [NSString stringWithFormat:@"%@%d/%@/",SQCocoaHttpServerBase,SQCocoaHttpServerPort,fileId];
    NSString * resultLocalPath = [segmentPrefix stringByAppendingString:[NSString stringWithFormat:@"%@.m3u8", fileName]];
    //如果已存在.m3u8直接返回播放地址
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
        DebugLog(@"m3u8已存在");
        return resultLocalPath;
    } else {
        DebugLog(@"写入m3u8");
    }
    //填充片段数据
    {
        NSString* filename = [NSString stringWithFormat:@"%@.ts", fileName];
        //            M3U8SegmentInfo* segInfo = [self.playlist getSegment:i];
        NSString* length = [NSString stringWithFormat:@"#EXTINF:%ld,\n", (long)duration];
        NSString* url = [segmentPrefix stringByAppendingString:filename];
        head = [NSString stringWithFormat:@"%@%@%@\n", head, length, url];
    }
    //创建尾部
    NSString* end = @"#EXT-X-ENDLIST";
    head = [head stringByAppendingString:end];
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    BOOL bSucc =[writer writeToFile:fullpath options:(NSDataWritingAtomic )  error:&error];
    
    if (bSucc)
    {
        NSLog(@"create m3u8file succeed; fullpath:%@, content:%@", fullpath, head);
        return  resultLocalPath;
    }
    else
    {
        NSLog(@"create m3u8file failed:%@", error);
        //        return [segmentPrefix stringByAppendingString:[NSString stringWithFormat:@"%@.m3u8",fileName]];//nil;
        return nil;
    }
}

@end
