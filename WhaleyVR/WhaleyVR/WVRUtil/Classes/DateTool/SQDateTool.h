//
//  SNDateTool.h
//  soccernotes
//
//  Created by sqb on 15/8/20.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQDateTool : NSObject

+ (double)sysTimeSec;
+ (NSString *)month_day:(double)secondInterval;
+ (NSString *)yearForDate:(NSDate *)date;
+ (NSString *)monthForDate:(NSDate *)date;
+ (NSString *)dayForDate:(NSDate *)date;
+ (NSString *)year_month_dayForDate:(NSDate *)date;

/// 单位是 秒
+ (NSString *)year_month_day:(double)secondInterval;

+ (NSString *)year_month_day:(double)secondInterval withFormatStr:(NSString *)formatStr;
/// 单位是 秒
+ (NSString *)year_month_day_ch:(double)secondInterval;

/// 单位是 毫秒
+ (NSString *)month_day_hour_minute:(double)milisecondInterval;

/// 单位是 秒
+ (NSString *)hour_minute_second:(double)secondInterval;

+ (NSString *)hour_minute:(double)secondInterval withFormatStr:(NSString *)formatStr;

/// 单位是 秒
+ (NSString *)year_month_day_hour_minute_nian:(double)secondInterval;   //年月日

/// 单位是 秒
+ (NSString *)year_month_day_hour_minute_nian_liveStart:(double)secondInterval;

/// 单位是 毫秒
+ (NSString *)year_month_day_hour_minute:(double)milisecondInterval;

/// 单位是 秒
+ (NSString *)year_month_day_hour_minute_second:(double)secondInterval;

/// 单位是 秒
+ (NSString *)year_month_day_hour_minute_second_now:(double)seconds;

/// 单位是 秒
+ (NSString *)year_month_day_week:(double)secondInterval;

+ (NSString *)getCurTime;
+ (NSString *)getCurday_month_year;
+ (NSString *)getCurday_month_year:(NSDate *)date;
+ (NSString *)getCurhour_day_month:(NSDate *)date;
+ (NSString *)getCurday_month_yearWithformatStr:(NSString*)formatStr;
+ (NSString *)month:(double)secondInterval;
+ (NSString *)day:(double)secondInterval;
+ (NSString *)hour:(double)millisecond;
+ (int)getTheHourNum:(NSString *)beginDay endDay:(NSString *)endDay;
+ (int)getDayNumFromNowWithEndTime:(NSString *)endTime;
+ (int)getNotAbsDayNumFromNowWithEndTime:(NSString *)endTime;
+ (int)getHourNumFromNowWithEndTime:(NSString *)endTime;
+ (int)getMinuteNumFromNowWithEndTime:(NSString *)endTime;
+ (int)getSecondNumFromNowWithEndTime:(NSString *)endTime;

/// 单位是 秒
+ (NSString *)year_month_day_hour_minute_sinceFomeDate:(NSString *)since withTimeInterval:(double)seconds;

/// 单位是 秒
+ (NSString *)week:(double)secondInterval;
+ (int)compareNowWithDate:(NSString *)secDate;

+ (NSMutableDictionary *)dayWithDays:(int)days formatterStr:(NSString *)formatterStr;

/// 单位是 毫秒
+ (NSString *)month_day_hour_minute:(double)milisecondInterval withFormatStr:(NSString *)formatStr;

+ (NSString *)currentDurationString:(NSInteger)duration;
+ (NSString *)formatDurationString:(double)second;

@end
