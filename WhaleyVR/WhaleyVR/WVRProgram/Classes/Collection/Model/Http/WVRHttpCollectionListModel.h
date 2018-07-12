//
//  WVRHttpCollectionListModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/9/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRHttpCollectionModel.h"


@interface WVRHttpCollectionListModel : NSObject

@property (nonatomic) NSArray<WVRHttpCollectionModel*> *content;
@property (nonatomic) NSString* totalPages;

@end
