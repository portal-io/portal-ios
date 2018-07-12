//
//  WVRSQCachVideoInfo.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRCachVideoViewModel.h"
#import "SQDownloadManager.h"
#import "WVRSQCachCell.h"
#import "WVRSQCachTableDelegate.h"

@interface WVRCachVideoViewModel ()
/**
 cach tableView
 */
@property (nonatomic) UITableView* tableView;
@property (nonatomic) WVRSQCachTableDelegate * cachDelegate;
@property (nonatomic) NSMutableDictionary * cachOriginDic;


@property (atomic) NSMutableArray * queueDowningArray;

@property (nonatomic) WVRSQCachCellInfo* curDowningInfo;

@end

@implementation WVRCachVideoViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        if (!_cachVideoArray) {
            _cachVideoArray = [NSMutableArray array];
            [[SQDownloadManager sharedInstance] setMaxConcurrentDownloads:1];
        }
        if (!_queueDowningArray) {
            _queueDowningArray = [NSMutableArray array];
        }
    }
    return self;
}


- (WVRSQCachTableDelegate *)cachDelegate {
    
    if (!_cachDelegate) {
        _cachDelegate = [WVRSQCachTableDelegate new];
        _cachDelegate.editStyle = UITableViewCellEditingStyleDelete;
        _cachDelegate.canEdit = YES;
    }
    return _cachDelegate;
}

- (void)setCanEdit:(BOOL)canEdit {
    
    self.cachDelegate.canEdit = canEdit;
}

- (NSMutableDictionary *)cachOriginDic {
    
    if (!_cachOriginDic) {
        _cachOriginDic = [NSMutableDictionary dictionary];
    }
    return _cachOriginDic;
}

- (void)setDelegateForTableView:(UITableView*)tableView {
    
    self.tableView = tableView;
    self.view = tableView;
    tableView.delegate = self.cachDelegate;
    tableView.dataSource =self.cachDelegate;
}

-(void)cancleCurDownload
{
    if (self.curDowningInfo.downStatus == WVRSQDownViewStatusDowning) {
        [self pauseDownload:self.curDowningInfo];
    }
}
#pragma net video
- (void)loadNetDBVideoInfo {
    
    kWeakSelf(self);
    SQShowProgressIn(self.tableView);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakself asyncLoadDBVideoInfo];
    });
}

- (void)asyncLoadDBVideoInfo {
    kWeakSelf(self);
    if (self.cachVideoArray.count>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SQHideProgressIn(weakself.tableView);
        });
        return ;
    }
    [self.cachVideoArray addObjectsFromArray:[WVRVideoModel searchAllFromDBWithDownFlag:YES]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself updateDownloadVideoUI];
    });
}

- (void)updateDownloadVideoUI {
    
    SQHideProgressIn(self.tableView);
    if (self.cachVideoArray.count == 0) {
        [self showArrNullView:@"无缓存视频" icon:@"icon_cach_video_empty"];
        self.isNullData = YES;
        if (self.delAllBlock) {
            self.delAllBlock(YES);
        }
        return;
    }
    self.isNullData = NO;
    if (self.delAllBlock) {
        self.delAllBlock(NO);
    }
    [self clearNullView];
    [self requestCachInfo];
}

- (void)requestCachInfo {
    
    kWeakSelf(self);
    self.cachOriginDic[@(SQTableViewSectionStyleFir)] = [self getCachSectionInfo];
    [self.cachDelegate loadData:^NSDictionary *{
        return weakself.cachOriginDic;
    }];
    [self.tableView reloadData];
    if (!self.curDowningInfo) {
        [self startNextDown];
    }
}

- (void)doMultiDelete {
    
    kWeakSelf(self);
    if (self.tableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        if (indexPaths.count==0) {
            return;
        }
        dispatch_group_t dGroup = dispatch_group_create();
        
        SQTableViewSectionInfo * sectionInfo = self.cachOriginDic[@(SQTableViewSectionStyleFir)];
        // 便利所有的行号
        NSMutableArray *deletedDeals = [NSMutableArray array];
        NSMutableArray * videos = [NSMutableArray array];
        __block BOOL shouldNextDown = NO;
        for (NSIndexPath *path in indexPaths) {
            dispatch_group_async(dGroup, dispatch_get_global_queue(0, 0), ^{
                
                
                WVRSQCachCellInfo * cellInfo = sectionInfo.cellDataArray[path.row];
                [deletedDeals addObject:cellInfo];
                [videos addObject:cellInfo.videoModel];
                if (shouldNextDown) {
                    
                }else{
                    shouldNextDown = [self multiDelete:cellInfo];
                }
            });
        }
        dispatch_group_notify(dGroup, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 删除模型数据
                [sectionInfo.cellDataArray removeObjectsInArray:deletedDeals];
                [weakself.cachVideoArray removeObjectsInArray:videos];
                // 刷新表格  一定要刷新数据
                [weakself.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                if (weakself.cachVideoArray.count == 0) {
                    weakself.curDowningInfo = nil;
                    [weakself showArrNullView:@"无缓存视频" icon:@"icon_cach_video_empty"];
                    if (weakself.delAllBlock) {
                        weakself.delAllBlock(YES);
                    }
                    weakself.isNullData = YES;
                }else{
                    
                    if (shouldNextDown) {
                        [weakself startNextDown];
                    }
                    
                    
                }
                weakself.completeBlock();
            });
            });
    }
}

- (SQTableViewSectionInfo*)getCachSectionInfo {
    
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    
    for (WVRVideoModel * model in self.cachVideoArray) {
        
        [sectionInfo.cellDataArray addObject:[self getCellInfo:model]];
    }
    
    for (WVRSQCachCellInfo* cachCellInfo in sectionInfo.cellDataArray) {
        if (cachCellInfo.videoModel.downStatus == WVRVideoDownloadStatusDowning) {
            if ([self checkPermitDownload]) {
                [self startDownload:cachCellInfo];
            }else{
                cachCellInfo.downStatus = WVRSQDownViewStatusPrepare;
            }
            break;
        }
    }
    
    return sectionInfo;
}

- (WVRSQCachCellInfo*)getCellInfo:(WVRVideoModel*)model {
    
    NSLog(@"model download status:%ld",(long)model.downStatus);
    kWeakSelf(self);
    WVRSQCachCellInfo* cachCellInfo = [WVRSQCachCellInfo new];
    cachCellInfo.cellNibName = [WVRSQCachCell description];
    cachCellInfo.cellHeight = 89;
    cachCellInfo.videoModel = model;
    [self initDownStatus:cachCellInfo];
    cachCellInfo.gotoNextBlock = ^(id args){
        if (weakself.tableView.allowsMultipleSelectionDuringEditing) {
            weakself.selectBlock();
            return ;
        }
        weakself.gotoPlayBlock(model);
    };
    __weak WVRSQCachCellInfo* blockCellInfo = cachCellInfo;
    cachCellInfo.pauseBlock = ^{
        [weakself pauseBlock:blockCellInfo];
    };
    
    cachCellInfo.prepareBlock = ^{
        [weakself prepareBlock:blockCellInfo];
    };
    
    cachCellInfo.restartBlock = ^{
        [weakself restartBlock:blockCellInfo];
    };
    
    cachCellInfo.willDeleteBlock = ^(id args){
        [weakself deleteItem:blockCellInfo];
        return NO;
    };
    cachCellInfo.deselectBlock = ^(id args){
        weakself.deselectBlock();
    };
    
    return cachCellInfo;
}

- (void)pauseBlock:(WVRSQCachCellInfo * )cellInfo {
    
    if (!cellInfo) {
        return;
    }
    if (cellInfo.downStatus == WVRSQDownViewStatusDown) {
        return;
    }
    if (self.curDowningInfo == cellInfo) {
        if (cellInfo.downStatus == WVRSQDownViewStatusDowning) {
            cellInfo.downStatus = WVRSQDownViewStatusPause;
            [self pauseDownload:cellInfo];
            [self startNextDown];
        }else{
            [self updateDownViewStatus:WVRSQDownViewStatusPause cellInfo:cellInfo];
        }
    }else{
        [self updateDownViewStatus:WVRSQDownViewStatusPause cellInfo:cellInfo];
    }
}

- (void)prepareBlock:(WVRSQCachCellInfo * )cellInfo {
    
    if (!cellInfo) {
        return;
    }
    if (cellInfo.downStatus == WVRSQDownViewStatusDown) {
        return;
    }
    if (self.curDowningInfo.downStatus == WVRSQDownViewStatusDowning) {
        self.curDowningInfo.downStatus = WVRSQDownViewStatusPrepare;
        [self pauseDownload:self.curDowningInfo];
    }
    if ([self checkPermitDownload]) {
        [self startDownload:cellInfo];
    }else{
        [self updateDownViewStatus:WVRSQDownViewStatusPrepare cellInfo:cellInfo];
    }
}

- (void)restartBlock:(WVRSQCachCellInfo*)cachCellInfo {
    [self updateDownViewStatus:WVRSQDownViewStatusPause cellInfo:self.curDowningInfo];//先暂停当前的缓存UI
    if ([WVRUserModel sharedInstance].isOnlyWifi){
        if ([WVRReachabilityModel sharedInstance].isWifi) {
            [self startDownload:cachCellInfo];
        }else{
            if ([WVRReachabilityModel sharedInstance].isNoNet) {
                SQToastInKeyWindow(@"请先连接wifi");
            }
        }
    }else{
        [self startDownload:cachCellInfo];
    }
}

- (void)initDownStatus:(WVRSQCachCellInfo* )cachCellInfo {
    
    WVRVideoDownloadStatus status = cachCellInfo.videoModel.downStatus;
    switch (status) {
        case WVRVideoDownloadStatusDown:
            cachCellInfo.downStatus = WVRSQDownViewStatusDown;
            break;
        
        case WVRVideoDownloadStatusPause:
            cachCellInfo.downStatus = WVRSQDownViewStatusPause;
            break;
        case WVRVideoDownloadStatusDowning:
            cachCellInfo.downStatus = WVRSQDownViewStatusDowning;
            break;
        case WVRVideoDownloadStatusPrepare:
            cachCellInfo.downStatus = WVRSQDownViewStatusPrepare;
            break;
        case WVRVideoDownloadStatusDownFail:
            cachCellInfo.downStatus = WVRSQDownViewStatusDownFail;
            break;
        default:
            break;
    }
}

- (void)deleteItem:(WVRSQCachCellInfo*)cellInfo {
    
    kWeakSelf(self);
    [UIAlertController alertTitle:@"是否删除缓存视频？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        [weakself deleteItemBlock:cellInfo];
    } cancleHandler:^(UIAlertAction *action) {
        
    } viewController:self.controller];
}

- (void)deleteItemBlock:(WVRSQCachCellInfo*)cellInfo {
    
    [[SQDownloadManager sharedInstance] cancelDownload:cellInfo.download andRemoveFile:YES];
    SQTableViewSectionInfo * sectionInfo = self.cachOriginDic[@(SQTableViewSectionStyleFir)];
    [sectionInfo.cellDataArray removeObject:cellInfo];
    [self.tableView reloadData];
    [cellInfo.videoModel deleteWithItemId:cellInfo.videoModel.itemId];
    [self.cachVideoArray removeObject:cellInfo.videoModel];
    if (cellInfo == self.curDowningInfo) {
        [self startNextDown];
    }
    if (self.cachVideoArray.count == 0) {
        self.curDowningInfo = nil;
        [self showArrNullView:@"无缓存视频" icon:@"icon_cach_video_empty"];
        if (self.delAllBlock) {
            self.delAllBlock(YES);
        }
        self.isNullData = YES;
    }
}

- (BOOL)multiDelete:(WVRSQCachCellInfo*)cellInfo {
    
    BOOL sholudNext =NO;
    [[SQDownloadManager sharedInstance] cancelDownload:cellInfo.download andRemoveFile:YES];
    
    [cellInfo.videoModel deleteWithItemId:cellInfo.videoModel.itemId];
    
    if (cellInfo == self.curDowningInfo) {
        sholudNext = YES;
    }
    return sholudNext;
}

- (BOOL)checkPermitDownload {
    
//    if ([WVRUserModel sharedInstance].isOnlyWifi){
        if ([WVRReachabilityModel sharedInstance].isWifi) {
            return YES;
        }else{
            SQToastInKeyWindow(@"切换到wifi网络下继续缓存");
            return NO;
        }
//    }
    return YES;
}

- (void)startDownload:(WVRSQCachCellInfo*)cellInfo {
    
    NSLog(@"start download");
    if(![self checkFreeSpace:0 totalBytesExpectedToWrite:1024*1024*100]){
        return;
    }
    self.curDowningInfo = cellInfo;
    self.curDowningInfo.isStart = YES;
    __weak typeof(self) weakSelf = self;
    cellInfo.downStatus = WVRSQDownViewStatusDowning;
    cellInfo.videoModel.isDownload = YES;
    [self updateDownViewStatus:WVRSQDownViewStatusDowning cellInfo:cellInfo];
    SQDownload * download = [[SQDownloadManager sharedInstance] downloadFileAtURL:[NSURL URLWithString:cellInfo.videoModel.downLink] toDirectory:[NSURL URLWithString:[cellInfo.videoModel.pathToFile stringByAppendingPathComponent:cellInfo.videoModel.fileName]] withName:cellInfo.videoModel.fileName progression:^(float progress, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        NSLog(@"progress: %f",progress);
        [weakSelf progressBlock:cellInfo progress:progress totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    } completion:^(NSError * _Nullable error, NSURL * _Nullable location) {
        NSLog(@"error: %@\n location: %@",error.description ,location.absoluteString);
        [weakSelf competionBlock:error location:location cellInfo:cellInfo];
    } isReStart:cellInfo.shouldReDown];
    cellInfo.shouldReDown = NO;
    cellInfo.download = download;
}

- (void)competionBlock:(NSError*)error location:(NSURL*)location cellInfo:(WVRSQCachCellInfo*)cellInfo {
    
    if (!error) {
        cellInfo.downStatus = WVRSQDownViewStatusDown;
        [self updateDownViewStatus:WVRSQDownViewStatusDown cellInfo:cellInfo];
        [self startNextDown];
    }else
    {
        if (error.code == 2 || error.code == 4) {
            cellInfo.shouldReDown = YES;
        }else{
        
        }
        [self updateDownViewStatus:WVRSQDownViewStatusDownFail cellInfo:cellInfo];
    }
}

- (BOOL)startNextDown {
    
    SQTableViewSectionInfo* sectionInfo = self.cachOriginDic[@(SQTableViewSectionStyleFir)];
    for (WVRSQCachCellInfo* cachCellInfo in sectionInfo.cellDataArray) {
        NSLog(@"nextDownStatus:%ld",cachCellInfo.videoModel.downStatus);
        if (cachCellInfo == self.curDowningInfo) {
            continue;
        }
        if (cachCellInfo.videoModel.downStatus == WVRVideoDownloadStatusPrepare || cachCellInfo.videoModel.downStatus == WVRVideoDownloadStatusDowning) {
            if ([self checkPermitDownload]) {
                [self startDownload:cachCellInfo];
            }else{
                cachCellInfo.downStatus = WVRSQDownViewStatusPrepare;
            }
            return YES;
        }
    }
    return NO;
}

- (void)updateDownViewStatus:(WVRSQDownViewStatus)status cellInfo:(WVRSQCachCellInfo*)cellInfo {
    
    if (cellInfo.updateProgressBlock) {
        cellInfo.updateDownStatusBlock(status);
    }
    switch (status) {
        case WVRSQDownViewStatusDowning:
            cellInfo.videoModel.downStatus = WVRVideoDownloadStatusDowning;
            break;
        case WVRSQDownViewStatusDown:
            cellInfo.videoModel.downStatus = WVRVideoDownloadStatusDown;
            break;
        case WVRSQDownViewStatusDownFail:
            cellInfo.videoModel.downStatus = WVRVideoDownloadStatusDownFail;
            break;
        case WVRSQDownViewStatusPause:
            cellInfo.videoModel.downStatus = WVRVideoDownloadStatusPause;
            break;
        case WVRSQDownViewStatusPrepare:
            cellInfo.videoModel.downStatus = WVRVideoDownloadStatusPrepare;
            break;
        default:
            break;
    }
    cellInfo.downStatus = status;
    [cellInfo.videoModel save];
}

- (void)progressBlock:(WVRSQCachCellInfo * )cellInfo progress:(CGFloat)progress totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    [self updateVideoModelTotalSize:cellInfo totalBytesWritten:totalBytesExpectedToWrite];
    if(cellInfo.download.fileSize==0){
        cellInfo.download.fileSize = cellInfo.videoModel.totalSize;
    }
    //    NSLog(@"taskIdentifier:%ld",cellInfo.download.downloadTask.taskIdentifier);
    cellInfo.videoModel.downProgress = progress;
    if (cellInfo.updateProgressBlock) {
        cellInfo.updateProgressBlock(progress);
    }
    [self checkFreeSpace:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (BOOL)checkFreeSpace:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    int64_t freeSize = [self freeDiskSpace].longLongValue;
    
//    NSLog(@"freeSize:%lld totalBytesExpectedToWrite:%lld",freeSize,totalBytesExpectedToWrite);
    kWeakSelf(self);
    if (totalBytesExpectedToWrite-totalBytesWritten > freeSize) {
        self.curDowningInfo.downStatus = WVRSQDownViewStatusPause;
        [self pauseDownload:self.curDowningInfo];
        int size = (float)(totalBytesExpectedToWrite-totalBytesWritten)/1024.f/1024.f;
        NSString * msgStr = [NSString stringWithFormat:@"剩余空间不足%dM，为保护您的设备，\n已为你暂停缓存，请清理后继续",size];
        [UIAlertController alertTitle:@"缓存暂停" mesasge:msgStr preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            if (weakself.editBlock) {
                weakself.editBlock();
            }
        } confirmTitle:@"确定"
                        cancleHandler:^(UIAlertAction *action) {
            
        } cancleTitle:@"取消"
         
                       viewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        return NO;
    }else{
        return YES;
    }
}

- (void)updateVideoModelTotalSize:(WVRSQCachCellInfo * )cellInfo totalBytesWritten:(int64_t)totalBytesExpectedToWrite {
    
    if (cellInfo.videoModel.totalSize == 0) {
        cellInfo.videoModel.totalSize = totalBytesExpectedToWrite;
        [cellInfo.videoModel save];
    }else{
        
    }
}

- (void)pauseDownload:(WVRSQCachCellInfo *)cellInfo {
    
    if (!cellInfo) {
        return;
    }
    if (cellInfo.downStatus == WVRSQDownViewStatusDown) {
        return;
    }
    self.curDowningInfo.isStart = NO;
    [self updateDownViewStatus:cellInfo.downStatus cellInfo:cellInfo];
    [[SQDownloadManager sharedInstance] cancelDownload:cellInfo.download WithResumeData:^(NSData * _Nullable resumeData) {
        // MARK: - 暂停过程中把下载按钮设置不可点击，暂停block回掉后再恢复可点击
        NSLog(@"cancel withResumeData");
    }];
    cellInfo.download = nil;
}


- (void)addDownTask:(WVRVideoModel *)videoModel {
    
    kWeakSelf(self);
    if (self.cachVideoArray.count==0) {
        [self loadNetDBVideoInfo];
    }else{
        [self.cachVideoArray addObject:videoModel];
        SQTableViewSectionInfo* sectionInfo = self.cachOriginDic[@(SQTableViewSectionStyleFir)];
        if (!sectionInfo) {
            sectionInfo = [SQTableViewSectionInfo new];
            [self.cachDelegate loadData:^NSDictionary *{
                return weakself.cachOriginDic;
            }];
            self.cachOriginDic[@(SQTableViewSectionStyleFir)] = sectionInfo;
        }
        WVRSQCachCellInfo * cellInfo = [self getCellInfo:videoModel];
        [sectionInfo.cellDataArray addObject:cellInfo];
        
        if (![self checkHaveDowningTask:sectionInfo.cellDataArray]) {
            [self startDownload:cellInfo];
        }
        
        [self.tableView reloadData];
        weakself.isNullData = NO;
        if (self.delAllBlock) {
            self.delAllBlock(NO);
        }
    }
}

- (BOOL)checkHaveDowningTask:(NSArray *)array {
    
//    BOOL haveDowning = NO;
    for (WVRSQCachCellInfo * cur in array) {
        if (cur.videoModel.downStatus == WVRVideoDownloadStatusDowning) {
//            haveDowning = YES;
            return YES;
        }
    }
    return NO;
}


- (BOOL)checkPermitDownloadWhenNetChange {
    
    if ([WVRUserModel sharedInstance].isOnlyWifi){
        if ([WVRReachabilityModel sharedInstance].isWifi) {
            return YES;
        }else{
            
            return NO;
        }
    }
    return YES;
}

- (void)startDownWhenHaveNet {
    
    self.tableView.userInteractionEnabled = NO;
    if (self.curDowningInfo) {
        [self checkCurDowningInfo];
    }else{
        [self startNextDown];
    }
    self.tableView.userInteractionEnabled = YES;
}

- (void)checkCurDowningInfo {
    
    BOOL canDownload = [WVRReachabilityModel sharedInstance].isWifi;//[self checkPermitDownload];//
    switch (self.curDowningInfo.downStatus) {
        case WVRSQDownViewStatusPrepare:
            if (canDownload){
                NSLog(@"change to wifi and start download");
                [self startDownload:self.curDowningInfo];
            }else{
                self.curDowningInfo.downStatus = WVRSQDownViewStatusPrepare;
            }
            break;
        case WVRSQDownViewStatusDowning:
            if (canDownload){
                //                if (!self.curDowningInfo.isStart) {
                //                [self.curDowningInfo.download resume];
                //                }
            }else{
                NSLog(@"change to 蜂窝 and pause download");
                self.curDowningInfo.downStatus = WVRSQDownViewStatusPause;
                SQToastInKeyWindow(@"非wifi网络，已为你暂停");
                [self pauseDownload:self.curDowningInfo];
                //                [self.curDowningInfo.download suspend];
                //                [[SQDownloadManager sharedInstance] resumeDownload:self.curDowningInfo.download];
            }
            break;
        case WVRSQDownViewStatusPause:
            if (canDownload){
                NSLog(@"change to wifi and start download");
                [self startDownload:self.curDowningInfo];
            }else{
                self.curDowningInfo.downStatus = WVRSQDownViewStatusPrepare;
            }
            break;
        default:
            break;
    }
}

- (NSNumber *)freeDiskSpace {
    
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}
@end
