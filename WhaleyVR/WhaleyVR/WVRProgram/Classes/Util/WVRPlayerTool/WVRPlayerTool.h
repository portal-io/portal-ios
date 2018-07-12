//
//  WVRPlayerTool.h
//  WhaleyVR
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WhaleyVRPlayer/WVRDataParam.h>
@class WVRPlayerToolModel, WVRVideoEntity, WVRItemModel, WVRHistoryModel;


typedef NS_ENUM(NSInteger, WVRVideoStreamType) {
    
    WVRVideoStreamTypeNormal = 0,     // 默认，原生播放按钮触发跳转
    WVRVideoStreamTypeCache,          // 缓存/下载 视频播放
    WVRVideoStreamTypeLocal,          // 本地视频播放
    WVRVideoStreamTypeWeb,            // H5页面跳转
};

@interface WVRPlayerTool : NSObject

//#warning - 禁止在模态界面push，modal播放器界面

+ (void)showPlayerControllerWith:(WVRPlayerToolModel *)tModel;

/**
 *  播放器界面统一入口
 *
 *  @param title        播放页标题
 *  @param isLocalVideo 区分本地/网络视频
 *  @param type         视频详情类型
 *  @param sid          sid 上传播放次数
 *  @param playURL      播放地址
 *  @param iconURL      详情图片 记录播放历史
 *  @param videoTag     tag 记录播放历史
 *  @param duration     时长
 *  @param nav          当前导航控制器
 */
+ (void)showPlayerControllerWithTitle:(NSString *)title
                            videoType:(WVRVideoStreamType)type
                           detailType:(WVRVideoDetailType)detailType
                                  sid:(NSString *)sid
                               webURL:(NSString *)webURL
                              playURL:(NSString *)playURL
                                 icon:(NSString *)iconURL
                                  tag:(NSString *)videoTag
                         resourceCode:(NSString *)resourceCode
                            totalTime:(NSInteger)duration
                           Controller:(UINavigationController *)nav __attribute__((deprecated("use showPlayerControllerWith: instead")));

//+ (void)showPlayerControllerWithTitle:(NSString *)title
//                            videoType:(WVRVideoStreamType)type
//                           detailType:(WVRVideoDetailType)detailType
//                                  sid:(NSString *)sid
//                               webURL:(NSString *)webURL
//                              playURL:(NSString *)playURL
//                                 icon:(NSString *)iconURL
//                                  tag:(NSString *)videoTag
//                         resourceCode:(NSString *)resourceCode
//                            totalTime:(NSInteger)duration
//                            oritation:(FrameOritation)localVideoOritaion
//                           Controller:(UINavigationController *)nav __attribute__((deprecated("use showPlayerControllerWith: instead")));

/**
 进入全屏播放控制器

 @param itemModel 当前要播放的节目
 @param items （专题类）节目列表，非专题的话可以传 nil
 */
+ (void)showPlayerVCWithModel:(WVRItemModel *)itemModel items:(NSArray *)items;


//+ (void)recordPlayHistory:(NSInteger)type totalTime:(NSInteger)totalTime videoTag:(NSString *)videoTag sid:(NSString *)sid title:(NSString *)title imageURL:(NSString *)icon resourceCode:(NSString *)resourceCode ;

+ (void)recordPlayHistory:(WVRHistoryModel *)historyModel;

+ (NSString *)wasuMovieRealPlayUrlWithUrl:(NSString *)playUrl;

@end


//MARK: - 以后本类将不再维护
@interface WVRPlayerToolModel : NSObject

// 通用，必传
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *playURL;
@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, assign) WVRVideoStreamType type;
@property (nonatomic, assign) WVRVideoDetailType detailType;

// 可选：播放页可根据sid请求获取
@property (nonatomic, assign) BOOL isChargeable;
@property (nonatomic, assign) long price;
@property (nonatomic, strong) NSArray* detailItemModels;
// 直播
@property (nonatomic, assign) long playCount;
@property (nonatomic, copy) NSString *iconURL;

// 点播：普通全景 3D电影
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString *videoTag;
@property (nonatomic, copy) NSString *resourceCode;

@property (nonatomic, copy) NSString *renderType;

// 专题，电视剧（连播）
//@property (nonatomic, weak) NSArray<WVRItemModel *> *detailItemModels;

// 本地/缓存
//@property (nonatomic) FrameOritation oritaion;

// 预留
@property (nonatomic, copy) NSString *webURL;


- (instancetype)initWithTitle:(NSString *)title
                    videoType:(WVRVideoStreamType)type
                   detailType:(WVRVideoDetailType)detailType
                          sid:(NSString *)sid
                       webURL:(NSString *)webURL
                      playURL:(NSString *)playURL
                         icon:(NSString *)iconURL
                          tag:(NSString *)videoTag
                 resourceCode:(NSString *)resourceCode
                    totalTime:(NSInteger)duration
                    playCount:(long)playCount
                   Controller:(UINavigationController *)nav;



@end
