//
//  WVRSQDownView.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WVRSQDownViewStatus){
    WVRSQDownViewStatusDefault,
    WVRSQDownViewStatusPrepare,
    WVRSQDownViewStatusDowning,
    WVRSQDownViewStatusPause,
    WVRSQDownViewStatusDown,
    WVRSQDownViewStatusDownFail,
    WVRSQDownViewStatusFailShoulReStart,
};

@protocol WVRSQDownViewDelegate <NSObject>

@required
- (void)startDownOnClick;
- (void)pauseDownOnClick;
- (void)stopDownOnClick;

@end


@interface WVRSQDownViewInfo : NSObject

@property (nonatomic) WVRSQDownViewStatus downStatus;
@property (nonatomic, copy) void(^startDownBlock)(void);
@property (nonatomic, copy) void(^pauseDownBlock)(void);
@property (nonatomic, copy) void(^prepareDownBlock)(void);
@property (nonatomic, copy) void(^restartDownBlock)(void);
@property (nonatomic,copy) void(^stopDownBlock)(void);
@property (nonatomic, weak) id<WVRSQDownViewDelegate> delegate;

@end


@interface WVRSQDownView : UIView

+ (instancetype)loadView;
- (void)updateTitle:(NSString*)defaultTitle downingTitle:(NSString*)downingTitle pauseTitle:(NSString*)pauseTitle downTitle:(NSString*)downTitle downFailTitle:(NSString*)downFailTitle;

- (void)reloadData;
- (void)updateViewWithInfo:(WVRSQDownViewInfo*)viewInfo;
- (void)updateWithStatus:(WVRSQDownViewStatus)status;
- (void)updateProgress:(float)progress;
- (void)updateViewFrame;

@end
