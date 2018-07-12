//
//  WVRHistoryModelReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/29.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHistoryModelReformer.h"
#import "WVRHistoryModel.h"
#import "WVRHttpHistoryListModel.h"
#import "WVRSectionModel.h"
#import "SQDateTool.h"

@implementation WVRHistoryModelReformer

#pragma - mark WVRAPIManagerDataReformer protocol
- (NSArray<WVRSectionModel*> *)reformData:(NSDictionary *)data {
    NSDictionary *businessDictionary = [super reformData:data];
    WVRHttpHistoryListModel *businessModel = [WVRHttpHistoryListModel yy_modelWithDictionary:businessDictionary];
    
    NSMutableArray * itemModels = [NSMutableArray new];
    for (WVRHttpHistoryItemModel * element in [businessModel content]) {
        WVRHistoryModel * itemModel = [WVRHistoryModel new];
        itemModel.uid = element.id;
        itemModel.playTime = element.playTime;
        itemModel.programName = element.programName;
        itemModel.totalPlayTime = element.totalPlayTime;
        itemModel.status = element.status;
        itemModel.programCode = element.programCode;
        itemModel.programType = element.programType;
        itemModel.moreTVType = element.type;
        if ([element.programType isEqualToString:PROGRAMTYPE_PROGRAM]) {
            itemModel.programType = PROGRAMTYPE_RECORDED;
        }else if ([element.programType isEqualToString:PROGRAMTYPE_MORETV]) {
            if ([element.type isEqualToString:@"tv"]) {
                itemModel.programType = PROGRAMTYPE_MORETV_TV;
            }else if ([element.type isEqualToString:@"movie"]){
                itemModel.programType = PROGRAMTYPE_MORETV_MOVIE;
            }
            
        }
        itemModel.thubImageUrl = element.programImgUrl;
        itemModel.curEpisode = element.curEpisode;
        
        itemModel.reportTime = element.reportTime;
        [itemModels addObject:itemModel];
    }
    
    return [self parseHistoryList:itemModels];;
}

-(NSArray<WVRSectionModel*>*)parseHistoryList:(NSArray<WVRHistoryModel*>*)list
{
    NSMutableArray * rewardSections = [NSMutableArray array];
        list = [list sortedArrayUsingComparator:^NSComparisonResult(WVRHistoryModel*  _Nonnull obj1, WVRHistoryModel*  _Nonnull obj2) {
            if (obj1.reportTime.doubleValue > obj2.reportTime.doubleValue) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
    NSMutableArray * resultList = [NSMutableArray array];
    NSMutableArray * rewardTimekeys = [NSMutableArray array];
    for (WVRHistoryModel* cur in list) {
        cur.formatDateStr = [SQDateTool month_day_hour_minute:[cur.reportTime doubleValue] withFormatStr:@"MM月dd日 HH:mm"];
        
        cur.formatDateKey = [SQDateTool month_day:[cur.reportTime doubleValue]];
        [self parseDay:cur];
        [resultList addObject:cur];
        if (![rewardTimekeys containsObject:cur.formatDateKey]) {
            [rewardTimekeys addObject:cur.formatDateKey];
        }
    }
    
    for (NSString * key in rewardTimekeys) {
        WVRSectionModel * sectionModel = [WVRSectionModel new];
        NSMutableArray * rewards = [NSMutableArray array];
        sectionModel.formatDateKey = key;
        for (WVRHistoryModel* model in resultList) {
            if ([model.formatDateKey isEqualToString:key]) {
                [rewards addObject:model];
            }
        }
        sectionModel.itemModels = rewards;
        [rewardSections addObject:sectionModel];
    }
    return rewardSections;
}

-(void)parseDay:(WVRHistoryModel* )cur
{
    int days = [SQDateTool getDayNumFromNowWithEndTime:cur.reportTime];
    if (days==0) {
        cur.formatDateKey = @"今天";
    }else if(days == 1){
        cur.formatDateKey = @"昨天";
    }
//    NSString * curTime = [SQDateTool year_month_day:[cur.reportTime doubleValue]/1000];
//    NSArray * curTimes = [curTime componentsSeparatedByString:@"-"];
//    NSString * nowTime = [SQDateTool getCurday_month_year];
//    NSArray * nowTimes = [nowTime componentsSeparatedByString:@"-"];
//    if ([curTime isEqualToString:nowTime]) {
//        cur.formatDateKey = @"今天";
//    }
//    
//    if (curTimes.count==3&& nowTimes.count) {
//        if ([curTimes[0] isEqualToString:nowTimes[0]]) {
//            if ([curTimes[1] isEqualToString:nowTimes[1]]) {
//                NSString * curDay = curTimes[2];
//                NSString * nowDay = nowTimes[2];
//                if ([nowDay intValue] - [curDay intValue] == 1) {
//                    cur.formatDateKey = @"昨天";
//                }
//            }
//            //不是同一个月的情况
//            if([curTimes[1] intValue] == [nowTimes[1] intValue]-1){
//                
//            }
//        }
//        
//    }
}
@end

