//
//  WVRSQArrangeMAHeader.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"
#import "WVRSectionModel.h"

@interface WVRSQArrangeMAHeaderInfo : SQCollectionViewHeaderInfo

@property (nonatomic) WVRSectionModel * sectionModel;
@property (nonatomic, assign) BOOL hidenPlayBtn;
@property (nonatomic,copy) void(^playStatusBlock)(CGFloat scale);

@property (nonatomic, assign) NSInteger subManualArrangeCount;

@end


@interface WVRSQArrangeMAHeader : SQBaseCollectionReusableHeader

@property (nonatomic, weak) WVRSectionModel *sectionModel;

- (void)playBtnStatusBlock:(CGFloat)scale;

@end
