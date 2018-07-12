//
//  WVRTVItemModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/1/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRItemModel.h"

@interface WVRTVPlayUrlModel : WVRBaseModel

@property (nonatomic) NSString * playUrl;
@property (nonatomic) NSString * source;
@property (nonatomic) NSString * threedType;

@end


@interface WVRTVItemModel : WVRItemModel

@property (nonatomic) NSString * parentCode;
@property (nonatomic) NSArray* tags_;

@property (nonatomic) NSString *curEpisode;

@property (nonatomic) WVRVideoDetailType detailType;

@property (nonatomic) NSMutableArray<WVRTVPlayUrlModel *>* playUrlModels;

@property (nonatomic) NSMutableArray<WVRTVItemModel *>* tvSeries;

@property (nonatomic) BOOL haveCollection;

#pragma mark - getter

- (NSArray *)playUrlArray;    // 规避迅雷源的电视剧无法seek的问题

@end
