//
//  WVRWebView.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/3.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WVRHybridConst.h"
#import "WVRWebRequest.h"
@class WVRWebView, WVRVideoEntity, WVRWebPlayModel, WVRItemModel;

typedef NS_ENUM(NSInteger, WVRWebViewUseType) {
    
    WVRWebViewUseTypeNormal,
//    WVRWebViewUseTypePlayer,
    WVRWebViewUseTypeHybrid,
    WVRWebViewUseTypeNews,      // 资讯
};

typedef NS_ENUM(NSInteger, WVRWebViewLoadStatus) {
    
    WVRWebViewLoadStatusLoading,
    WVRWebViewLoadStatusFailed,
    WVRWebViewLoadStatusLoaded,
};

@protocol WVRWebViewDelegate <NSObject>

@required
//MARK: - 生命周期
- (void)webViewDidLoad;
- (void)webViewLoadFail;

- (void)actionOnExit;

@optional

- (void)actionGoGiftPage;

//MARK: - Hybrid action
- (void)actionSetIsHybridPage:(BOOL)isHybrid;
- (NSString *)actionGetLoginInfo;
- (void)actionToLoginWithCallbackId:(NSString *)callbackId;
- (void)actionSetIsLoadOver;
- (void)actionShowImages:(NSDictionary *)imagesDict;
- (void)actionShareWithInfo:(NSDictionary *)shareInfo callbackId:(NSString *)callbackId;
- (void)actionJumpPageWithInfo:(NSDictionary *)infoDict;
- (void)actionJumpToInsideWebPage:(NSDictionary *)infoDict;
- (void)actionDoHttpRequest:(WVRWebRequest *)webRequest;
- (void)actionJump:(NSDictionary *)itemModelDic;

@end


@interface WVRWebView : UIWebView

@property (nonatomic, readonly) NSString *urlStr;
@property (nonatomic, readonly) WVRWebViewUseType useType;
@property (nonatomic, weak) id<WVRWebViewDelegate> realDelegate;

@property (nonatomic, strong) NSCharacterSet *customCharacterSet;

@property (nonatomic, readonly) WVRWebViewLoadStatus loadStatus;

@property (atomic, assign) BOOL isDestroyed;

// MARK: - life cycle

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame URL:(NSString *)urlStr params:(NSDictionary *)param liveParam:(NSDictionary *)liveParam useType:(WVRWebViewUseType)useType;

- (void)reloadWithURL:(NSString *)url;

- (void)onBackForDestroy;

//MARK: - Hybrid

- (void)execCaptureExit;

- (void)execSend:(NSString *)callbackId withPayload:(NSDictionary *)payload;

/**
 H5获取keyboard
 
 @param isHide true:hide  false:show
 @param height default is 0
 */
- (void)execKeyboardHide:(BOOL)isHide keyboardHeight:(int)height;
- (void)execNetworkStatusChanged;

@end


@interface WVRWebPlayModel : NSObject

@property (nonatomic, assign) BOOL isLooping;
@property (nonatomic, assign) BOOL isMonocular;
@property (nonatomic, assign) BOOL useHardDecoder;
@property (nonatomic, copy  ) NSString *path;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger renderType;

@end

