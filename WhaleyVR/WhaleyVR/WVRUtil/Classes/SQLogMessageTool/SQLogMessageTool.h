//
//  SQLogMessageTool.h
//  QBDemo
//
//  Created by qbshen on 2016/12/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQSystemLogMessage : NSObject

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) NSDate* date;
@property (nonatomic) NSString* sender;
@property (nonatomic) NSString* messageText;
@property (nonatomic) long long messageID;

@end


@interface SQLogMessageTool : NSObject

+ (instancetype)shareInstance;
+ (void)saveLogMsgToWeb;
+ (NSMutableArray<SQSystemLogMessage *> *)allLogMessagesForCurrentProcess;

@end
