//
//  WVRSQCachTableDelegate.h
//  WhaleyVR
//
//  Created by qbshen on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRSQCachTableDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>
@property BOOL canEdit;
@property (nonatomic) UITableViewCellEditingStyle editStyle;
-(void)loadData:(NSDictionary *(^)(void)) loadDataBlock;
@end
