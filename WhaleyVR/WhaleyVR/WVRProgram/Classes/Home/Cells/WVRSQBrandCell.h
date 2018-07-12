//
//  WVRSQBrandCell.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/16.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionViewDelegate.h"

@interface WVRSQBrandCellInfo : SQCollectionViewCellInfo
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * subTitle;
@property (nonatomic) NSString * intrDesc;
@property (nonatomic) NSString * thubImage;
@property (nonatomic) NSString * scaleThubImage;
@property (nonatomic) NSString * unitConut;
@property (nonatomic) NSString * logoImageUrl;
@property (nonatomic) NSString * scaleLogoImageUrl;



@end
@interface WVRSQBrandCell : SQBaseCollectionViewCell

@end
