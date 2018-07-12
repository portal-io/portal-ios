//
//  WVRSQLocalVideoInfo.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/8.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQLocalVideoInfo.h"
#import "WVRSQCachCell.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import "WVRLocalHeader.h"

@interface WVRSQLocalVideoInfo ()

@property (nonatomic) UITableView* tableView;
@property (nonatomic) SQTableViewDelegate * localDelegate;
@property (nonatomic) NSMutableDictionary * localOriginDic;
@property (atomic) NSMutableArray * localVideoArray;
@property (atomic, strong) PHFetchResult<PHAsset *> *assetsFetchResults;

@end


@implementation WVRSQLocalVideoInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_localVideoArray) {
            _localVideoArray = [NSMutableArray array];
        }
    }
    return self;
}

- (SQTableViewDelegate *)localDelegate
{
    if (!_localDelegate) {
        _localDelegate = [SQTableViewDelegate new];
    }
    return _localDelegate;
}

- (NSMutableDictionary *)localOriginDic
{
    if (!_localOriginDic) {
        _localOriginDic = [NSMutableDictionary dictionary];
    }
    return _localOriginDic;
}


- (void)setDelegateForTableView:(UITableView*)tableView
{
    self.tableView = tableView;
    self.view = tableView;
    tableView.delegate = self.localDelegate;
    tableView.dataSource =self.localDelegate;
}

#pragma local load data
//加载视频
- (void)loadVideosInfo {
    [self requestAuthorStatus];
}

- (void)requestLocalInfo
{
    kWeakSelf(self);
    self.localOriginDic[@(SQTableViewSectionStyleFir)] = [self getLocalSectionInfo];
    [self.localDelegate loadData:^NSDictionary *{
        return weakself.localOriginDic;
    }];
    [self.tableView reloadData];
}

- (SQTableViewSectionInfo*)getLocalSectionInfo
{
    kWeakSelf(self);
    SQTableViewSectionInfo * sectionInfo = [SQTableViewSectionInfo new];
    
    for (WVRVideoModel * model in self.localVideoArray) {
        WVRSQCachCellInfo* localCellInfo = [WVRSQCachCellInfo new];
        localCellInfo.cellNibName = [WVRSQCachCell description];
        localCellInfo.cellHeight = 89;
        localCellInfo.videoModel = model;
        localCellInfo.hidenDownV = YES;
        localCellInfo.gotoNextBlock = ^(id args){
//            [self showPlayerCtrl:model];
            weakself.gotoPlayBlock(model);
        };
        [sectionInfo.cellDataArray addObject:localCellInfo];
    }
    
    return sectionInfo;
}


- (void)requestAuthorStatus
{
    kWeakSelf(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                [weakself requestPhotos];
            }
                break;
            default:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakself.completeBlock) {
                        weakself.completeBlock();
                    }
//                    SQToastInKeyWindow(@"请去设置功能下允许微鲸VR获取访问图片的权限");
                });
                break;
        }
    }];
}

- (void)requestPhotos {
    SQShowProgressIn(self.tableView);
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult<PHAsset *> *curAFRs = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:allPhotosOptions];
        if (curAFRs.count>_assetsFetchResults.count) {
            _assetsFetchResults = curAFRs;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                SQHideProgressIn(self.tableView);
            });
            return ;
        }
        if (_assetsFetchResults.count==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                SQToast(@"本地没有视频");
                [self showArrNullView:@"无本地视频" icon:@"local_video_empty"];
                if (weakself.completeBlock) {
                    weakself.completeBlock();
                }
            });
            return ;
        }
        [self clearNullView];
        [self createFoler:SQAVAssetExportSessionPATH];
        [self.localVideoArray removeAllObjects];
        [_assetsFetchResults enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
            //            NSLog(@"stop : %hhd ,index: %ld",*stop, (unsigned long)idx);
            [weakself enumerateObjectsUsingBlock:asset];
        }];
    });
}

- (void)enumerateObjectsUsingBlock:(PHAsset*)itemResultAsset
{
    kWeakSelf(self);
    PHImageRequestOptions *imageDataOptions = [[PHImageRequestOptions alloc] init];
    imageDataOptions.synchronous = YES;
    
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHVideoRequestOptions *videoOptions = [[PHVideoRequestOptions alloc] init];
    //    videoOptions.networkAccessAllowed = YES;
    
    WVRVideoModel *model = [[WVRVideoModel alloc] init];
    [self.localVideoArray addObject:model];
//    model.name = [self getFormatedDateStringOfDate:asset.creationDate];
    [[PHCachingImageManager defaultManager] requestImageForAsset:itemResultAsset targetSize:CGSizeMake(adaptToWidth(160), adaptToWidth(90)) contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        model.localThubImage = result;
        NSInteger index = [weakself.localVideoArray indexOfObject:model];
        if (weakself.tableView.numberOfSections>0) {
            NSInteger cellNum = [weakself.tableView numberOfRowsInSection:0];
            if (cellNum>index+1) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                if (indexPath) {
                    NSMutableArray* arr = [NSMutableArray array];
                    [arr addObject:indexPath];
                    [weakself.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }];
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:itemResultAsset options:imageDataOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSLog(@"orientation: %ld",orientation);
        model.totalSize = imageData.length;
        NSInteger index = [weakself.localVideoArray indexOfObject:model];
        if (weakself.tableView.numberOfSections>0) {
            NSInteger cellNum = [weakself.tableView numberOfRowsInSection:0];
            if (cellNum>index+1) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                if (indexPath) {
                    NSMutableArray* arr = [NSMutableArray array];
                    [arr addObject:indexPath];

                    [weakself.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }];
    
    [[PHCachingImageManager defaultManager] requestAVAssetForVideo:itemResultAsset options:videoOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        if ([asset isKindOfClass:[AVURLAsset class]])
        {
//            NSLog(@"degress: %ld",);
//            model.oritation = [self degressFromVideoFileWithURL:asset];
//            model.localUrl = [(AVURLAsset *)asset URL].absoluteString;
            NSString * fileName = [(AVURLAsset*)asset URL].absoluteString.lastPathComponent;
            model.name = [[fileName componentsSeparatedByString:@"."] firstObject];
            AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
            session.outputFileType = AVFileTypeMPEG4;
            session.outputURL = [NSURL fileURLWithPath:[[SQAVAssetExportSessionPATH stringByAppendingString:model.name] stringByAppendingString:@".mp4"]]; // 这个就是你可以导出的文件路径了。
            [session exportAsynchronouslyWithCompletionHandler:^{
                if (session.error) {
                    if(session.error.code == -11823){
                        model.localUrl = [session outputURL].absoluteString;
                    }else{
                        [weakself.localVideoArray removeObject:model];
                    }
                }else{
                    model.localUrl = [session outputURL].absoluteString;
                }
                if ([weakself.assetsFetchResults indexOfObject:itemResultAsset] == weakself.assetsFetchResults.count-1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SQHideProgressIn(self.tableView);
                        if (weakself.completeBlock) {
                            weakself.completeBlock();
                        }
                        [weakself requestLocalInfo];
                    });
                }
            }];
        }
    }];
}

//- (NSUInteger)degressFromVideoFileWithURL:(AVAsset *)asset {
//    
//    NSUInteger degress = 0;
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    if([tracks count] > 0) {
//        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
//        CGAffineTransform t = videoTrack.preferredTransform;
        
//        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
//            // Portrait
//            degress = 90;
//            return FRAME_ORITATION_PORTRAIT;
//        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
//            // PortraitUpsideDown
//            degress = 270;
//            return FRAME_ORITATION_PORTRAIT_UPSIDEDOWN;
//        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
//            // LandscapeRight
//            degress = 0;
//            return FRAME_ORITATION_LANDSCAPE_LEFT;
//        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
//            // LandscapeLeft
//            degress = 180;
//            return FRAME_ORITATION_LANDSCAPE_RIGHT;
//        }
//    }
//    
//    return degress;
//}

- (BOOL)createFoler:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        /** 创建 */
        NSError *error2;
        BOOL createSuc2 = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error2];
        if (!createSuc2) {
            NSLog(@"创建失败:%@", error2);
        }
        return createSuc2;
    }
    return YES;
}

//- (void)showEmptyContent {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        
//    });
//}

#pragma mark - tool

//将创建日期作为文件名
- (NSString*)getFormatedDateStringOfDate:(NSDate *)date {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   // 注意时间的格式：MM表示月份，mm表示分钟，HH用24小时制，小hh是12小时制。
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}


@end
