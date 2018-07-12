  //
//  LWSQLiteManager.m
//  LewoSVR
//
//  Created by iStig on 15/11/11.
//  Copyright © 2015年 Snailvr. All rights reserved.
//

#import "WVRSQLiteManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <sqlite3.h>

#import "SQMD5Tool.h"

// 混淆付费表
#define kChargedTable   @"alpha"
#define kChargedSid     @"aaa"
#define kExchangeCode   @"bbb"


@implementation WVRSQLiteManager

static NSString *const kDatabaseName = @"LW-DB.sqlite";

#pragma mark - initialize

+ (instancetype)sharedManager {
    
    static WVRSQLiteManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[WVRSQLiteManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        _databasePath = [documentsDir stringByAppendingPathComponent:kDatabaseName];
        
        _fmQueue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
        
        [self checkAndCreateDatabase];
        
        [self removeOutdatedADs];
    }
    return self;
}

- (void)checkAndCreateDatabase {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:self.databasePath];
    NSLog(@"LW-DB.sqlite is %@ Exist", isExist ? @"already": @"Not");
    
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL success = NO;
//        success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS videos (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, videoId text UNIQUE, videoName text, videoUrl text, videoPath text, videoState integer, videoTime text, videoProgress text, saveSize text, totalSize text, videoImage text, videoOnlineUrl text, videoSize text, videoDuration text, isViewed text, viewedTime text, vedioContent text, videoSliderValue text, videoOnplayTime text, resourceCode text)"];
        
        success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS iapOrders (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, orderNo text UNIQUE, iosProductCode text, goodsType text, goodsNo text, price text, uid text, phoneNo text, receipt text)"];
        
        success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS BIEvents (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Content TEXT)"];
        
        NSString *exec = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, %@ TEXT UNIQUE, %@ TEXT)", kChargedTable, kChargedSid, kExchangeCode];
        success = [db executeUpdate:exec];
        
        exec = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS AdInfo (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, AdType TEXT UNIQUE, AdCode TEXT, FirstShowTime REAL, LastShowTime REAL)"];
        success = [db executeUpdate:exec];
        
        [self logWithSuccess:success event:@"to create tables"];
    }];
}

#pragma mark - 苹果内购订单防止漏单管理

- (BOOL)insertIAPOrder:(NSDictionary *)dict {
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        success = [db executeUpdate:@"INSERT INTO iapOrders(orderNo, iosProductCode, goodsType, goodsNo, price, uid, phoneNo, receipt) VALUES(?,?,?,?,?,?,?,?)", dict[@"orderNo"], dict[@"iosProductCode"], dict[@"goodsType"], dict[@"goodsNo"], [NSString stringWithFormat:@"%@", dict[@"price"]], dict[@"uid"], dict[@"phoneNo"], dict[@"receipt"]];
    }];
    
    [self logWithSuccess:success event:@"add this to iapOrders"];
    
    return success;
}

- (NSArray<NSDictionary *> *)ordersInIAPOrder {
    
    __block NSMutableArray *orders = [NSMutableArray array];
    
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *results = [db executeQuery:@"SELECT * FROM iapOrders"];
        
        while ([results next]) {
            NSDictionary *order = [self iapOrderResult:results];
            [orders addObject:order];
        }
    }];
    
    return orders;
}

- (void)removeIAPOrder:(NSString *)orderNo {
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM iapOrders WHERE orderNo = \"%@\"", orderNo];
        
        success = [db executeUpdate:sql];
    }];
    
    [self logWithSuccess:success event:[NSString stringWithFormat:@"remove %@ from iapOrders", orderNo]];
}

- (void)removeAllIAPOrder {
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        success = [db executeUpdate:@"DELETE FROM iapOrders"];
    }];
    
    [self logWithSuccess:success event:@"remove all iapOrders"];
}

#pragma mark private

- (NSDictionary *)iapOrderResult:(FMResultSet *)results {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"orderNo"] = [results stringForColumn:@"orderNo"];
    dict[@"price"] = @([results longForColumn:@"price"]);
    dict[@"goodsType"] = [results stringForColumn:@"goodsType"];
    dict[@"goodsNo"] = [results stringForColumn:@"goodsNo"];
    dict[@"iosProductCode"] = [results stringForColumn:@"iosProductCode"];
    dict[@"uid"] = [results stringForColumn:@"uid"];
    dict[@"phoneNo"] = [results stringForColumn:@"phoneNo"];
    dict[@"receipt"] = [results stringForColumn:@"receipt"];
    
    return dict;
}

#pragma mark - BI Event Track

//Mark: - 增

- (BOOL)insertBIEvent:(NSString *)content {     // encode
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        success = [db executeUpdate:@"INSERT INTO BIEvents(Content) VALUES(?)", content];
    }];
    
    [self logWithSuccess:success event:@"add this to BIEvents"];
    
    return success;
}

//Mark: - 查

- (NSArray *)contentsInBIEvents {       // decode
    
    __block NSMutableArray *events = [NSMutableArray array];
    
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *results = [db executeQuery:@"SELECT * FROM BIEvents ORDER BY Id ASC"];
        
        while ([results next]) {
            _maxEventId = [results longForColumn:@"Id"];    // 取最大id值
            
            NSString *video = [results stringForColumn:@"Content"];
            
            [events addObject:video];
        }
    }];
    
    return [events copy];
}

//Mark: - 删

- (void)removeBIEventBelowId:(long)Id {
    
    if (Id <= 0) {
        Id = _maxEventId;
    }
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM BIEvents WHERE Id <= %ld", Id];
        
        success = [db executeUpdate:sql];
    }];
    
    [self logWithSuccess:success event:@"remove BIEvents"];
}


- (void)removeAllBIEvents {
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM BIEvents"];
        
        success = [db executeUpdate:sql];
    }];
    
    [self logWithSuccess:success event:@"remove BIEvents"];
}

- (void)logWithSuccess:(BOOL)success event:(NSString *)eventName {
    
    DDLogInfo(@"%@ to - %@", success ? @"Success": @"Fail", eventName);
}

// MARK: - AdInfos

- (BOOL)saveADWithCode:(NSString *)code adType:(NSString *)adType {
    
    if (!code) { return NO; }
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSNumber *num = @(now);
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM AdInfo WHERE AdType = \"%@\"", adType]];
        
        if ([results next]) {
            
            success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE AdInfo SET AdCode = \"%@\", LastShowTime = %@ WHERE AdType = '%@'", code, num, adType]];
        } else {
            
            success = [db executeUpdate:@"INSERT INTO AdInfo(AdType, AdCode, FirstShowTime, LastShowTime) VALUES(?,?,?,?)", adType, code, num, num];
        }
    }];
    
    [self logWithSuccess:success event:[NSString stringWithFormat:@"add %@ - %@ to AdInfo", adType, code]];
    
    return success;
}

- (NSTimeInterval)lastShowTimeForADCode:(NSString *)code adType:(NSString *)adType {
    
    __block NSTimeInterval time = 0;
    
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM AdInfo WHERE adType = \"%@\"", adType]];
        
        while ([results next]) {
            NSString *tmpCode = [results stringForColumn:@"AdCode"];
            if ([tmpCode isEqualToString:code]) {
                time = [results doubleForColumn:@"LastShowTime"];
            }
        }
    }];
    
    return time;
}

- (void)removeOutdatedADs {
    
    __block BOOL success = NO;
    [self.fmQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval time = now - 60 * 60 * 24 * 30;  // 默认有效期一个月
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM AdInfo WHERE LastShowTime < %f", time];
        
        success = [db executeUpdate:sql];
    }];
    
    [self logWithSuccess:success event:@"remove Outdated ADs"];
}

@end
