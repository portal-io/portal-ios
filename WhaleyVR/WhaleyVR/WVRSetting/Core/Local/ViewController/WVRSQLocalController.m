//
//  WVRSQLocalCachController.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/5.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQLocalController.h"
#import "SQSegmentView.h"
#import "SQPageView.h"
#import "SQTableView.h"

//#import "WVRPlayerVCLocal.h"
#import "WVRNavigationController.h"

//#import "WVRPlayerTool.h"
//#import "WVRVideoEntityLocal.h"
#import "SQCocoaHttpServerTool.h"
#import "WVRCachVideoViewModel.h"
#import "WVRSQLocalVideoInfo.h"

#import "WVRDeleteFooterView.h"

#import "WVRMediator+ProgramActions.h"


typedef NS_ENUM(NSInteger, WVRSQLocalSegmentType) {
    WVRSQLocalSegmentTypeCach = 0,
    WVRSQLocalSegmentTypeLocal,
};

#define HEIGHT_PAGEVIEW (self.view.frame.size.height-self.mSegmentV.y-self.mSegmentV.height)
#define FRAME_SUB_PAGEVIEW (CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PAGEVIEW))

@interface WVRSQLocalController ()

//<UIScrollViewDelegate>
//@property (nonatomic) SQSegmentView *mSegmentV;

//@property (nonatomic)  SQPageView *pageView;


/**
 cach tableView
 */
@property (nonatomic) WVRCachVideoViewModel * cachVideoInfo;

/**
 local tableView
 */
//@property (nonatomic) SQTableView * localTableView;
//@property (nonatomic) WVRSQLocalVideoInfo * localVideoInfo;

@end


@implementation WVRSQLocalController

+ (instancetype)shareInstance {
    
    static WVRSQLocalController * vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[WVRSQLocalController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
//        [vc initSegmentView];
//        [vc initPageView];
        
//        [vc.view addSubview:vc.gTableView];
    });
    return vc;
}

- (void)addDownTask:(WVRVideoModel *)videoModel {
    
    [self.cachVideoInfo addDownTask:videoModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mJ_header = nil;
    [[self cachVideoInfo] setDelegateForTableView:self.gTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self updateCachVideoInfo];//放在load里面只能调用一次该方法
}

-(void)httpSuccessBlock:(NSArray *)originArray
{
    
    
}

- (void)startDownWhenHaveNet {
    
    [self.cachVideoInfo startDownWhenHaveNet];
}
//
//- (void)setBackCompletionHandler:(void (^)(void))backCompletionHandler
//{
//    [self.cachVideoInfo setBackCompletionHandler:backCompletionHandler];
//}

-(void)cancleCurDownload
{
    [self.cachVideoInfo cancleCurDownload];
}

- (void)updateCachVideoInfo {
    
    [self.cachVideoInfo loadNetDBVideoInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.localVideoInfo loadVideosInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return  UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self changeToDefaultStatus];
}

- (void)initTitleBar {
    
    [super initTitleBar];
    self.title = @"本地缓存";
}

-(void)didSelectAllCell:(BOOL)selected {
    
    if ([self.gTableView numberOfSections]>0&&[self.gTableView numberOfRowsInSection:0]) {
        if (selected) {
            for (int i = 0; i < [self.gTableView numberOfRowsInSection:0]; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                
                [self.gTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }else{
            for (int i = 0; i < [self.gTableView numberOfRowsInSection:0]; i ++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                
                [self.gTableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        
    }
    [self updateSelectedCount];
}

- (WVRCachVideoViewModel *)cachVideoInfo {
    
    kWeakSelf(self);
    if (!_cachVideoInfo) {
        _cachVideoInfo = [[WVRCachVideoViewModel alloc] init];
        _cachVideoInfo.controller = self;
        _cachVideoInfo.gotoPlayBlock = ^(WVRVideoModel* model){
            [weakself gotoCacheVideoPlayer:model];
        };
        _cachVideoInfo.completeBlock = ^{
            [weakself hideProgress];
            [weakself updateSelectedCount];
        };
        _cachVideoInfo.delAllBlock = ^(BOOL delAll){
            [weakself changeToDefaultStatus];
            weakself.navigationItem.rightBarButtonItem = delAll? nil:weakself.editItem;
        };
        _cachVideoInfo.editBlock = ^{
            [weakself changeToEditStatus];
        };
        _cachVideoInfo.selectBlock = ^{
            [weakself updateSelectedCount];
        };
        _cachVideoInfo.deselectBlock = ^{
            [weakself updateSelectedCount];
        };
        
    }
    return _cachVideoInfo;
}

- (void)updateCachTV {
    
    [self.gTableView reloadData];
}

- (void)updateTableView {

    [self updateCachTV];
}

- (void)requestInfo {
    
}

- (void)requestCachInfo {
    
    [self updateCachTV];
}

#pragma mark - action

- (void)gotoCacheVideoPlayer:(WVRVideoModel*)videoModel {
    
    if (videoModel.downStatus != WVRVideoDownloadStatusDown) {
        SQToast(@"视频未缓存完成");
        return;
    }

    if (![SQCocoaHttpServerTool shareInstance].isrunning) {
        [[SQCocoaHttpServerTool shareInstance] openHttpServer];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = videoModel.itemId;
    params[@"title"] = videoModel.name;
    params[@"duration"] = @(videoModel.duration * 1000);
    params[@"renderType"] = @(videoModel.renderType);
    params[@"renderTypeStr"] = videoModel.renderTypeStr;
    params[@"definition"] = videoModel.definition;
    params[@"playURL"] = videoModel.localUrl;
    
    UIViewController * vc = [[WVRMediator sharedInstance] WVRMediator_PlayerVCLocal:params];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc {
    
    DDLogInfo(@"");
}

-(void)alertForMutilDel {
    
    if (self.gTableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSArray *indexPaths = [self.gTableView indexPathsForSelectedRows];
        if (indexPaths.count==0) {
            return;
        }
        kWeakSelf(self);
        [UIAlertController alertTitle:@"确定要删除吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            [weakself.cachVideoInfo doMultiDelete];
        } cancleHandler:^(UIAlertAction *action) {
            
        }  viewController:self];
    }
}

-(void)updateSelectedCount {
    
    NSArray* indexPaths = [self.gTableView indexPathsForSelectedRows];
    NSInteger totalCount = self.cachVideoInfo.cachVideoArray.count;
    NSString * title = [NSString stringWithFormat:@"删除（%ld/%ld）",(long)indexPaths.count,(long)totalCount];
    if(indexPaths.count == totalCount){
        [self.mDelFooterV updateSelectStatus:YES];
    }else{
        [self.mDelFooterV updateSelectStatus:NO];
    }
    [self.mDelFooterV updateDelTitle:title];
}

-(NSString *)nullViewTitle
{
    return @"无缓存视频";
}

-(NSString *)nullViewIcon
{
    return @"icon_cach_video_empty";
}
@end
