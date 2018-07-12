//
//  WVRHttpArrangeTreeModel.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRHttpArrangeTreeModel : NSObject

@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * createTime;
@property (nonatomic) NSString * updateTime;
@property (nonatomic) NSString * publishTime;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) NSString * position;
@property (nonatomic) NSString * buisnessVersion;
@property (nonatomic) NSString * appType;
@property (nonatomic) NSString * parentId;
@property (nonatomic) NSString * arrangeTreeElements;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * version;
@property (strong, nonatomic) NSArray<WVRHttpArrangeTreeModel*> * children;

@end
