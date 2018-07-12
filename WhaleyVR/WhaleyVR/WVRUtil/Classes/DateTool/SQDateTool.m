//
//  SNDateTool.m
//  soccernotes
//
//  Created by sqb on 15/8/20.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SQDateTool.h"

@implementation SQDateTool

+ (double)sysTimeSec {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return time;
}

+ (NSString *)month_day:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)yearForDate:(NSDate *)date {
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_dayForDate:(NSDate *)date {
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)monthForDate:(NSDate *)date {
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)dayForDate:(NSDate *)date {
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day:(double)secondInterval {
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day:(double)secondInterval withFormatStr:(NSString *)formatStr {
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
    //    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
    //    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_ch:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)month_day_hour_minute:(double)milisecondInterval {
    
    NSTimeInterval second = milisecondInterval;
    
    // 如果单位判断为毫秒则转换为秒
    if (milisecondInterval > 100000000000) {
        second = milisecondInterval / 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd  HH:mm"];
    //    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    //    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)month_day_hour_minute:(double)milisecondInterval withFormatStr:(NSString *)formatStr {
    
    NSTimeInterval second = milisecondInterval;
    
    // 如果单位判断为毫秒则转换为秒
    if (milisecondInterval > 100000000000) {
        second = milisecondInterval / 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];     // timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_hour_minute_nian:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日  HH:mm"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@", date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)year_month_day_hour_minute_nian_liveStart:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@", date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)hour_minute_second:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH时mm分ss秒"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)hour_minute:(double)secondInterval withFormatStr:(NSString *)formatStr
{
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
    //    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
    //    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_hour_minute:(double)milisecondInterval {
    
    NSTimeInterval second = milisecondInterval;
    
    // 如果单位判断为毫秒则转换为秒
    if (milisecondInterval > 100000000000) {
        second = milisecondInterval / 1000;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd  HH:mm"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
//    NSLog(@"date1:%@", date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}


+ (NSString *)year_month_day_hour_minute_second:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
    //    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_hour_minute_sinceFomeDate:(NSString *)since withTimeInterval:(double)seconds{

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *sinceDate = [formatter dateFromString:since];
    NSDate *date = [NSDate dateWithTimeInterval:seconds sinceDate:sinceDate];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_hour_minute_second_now:(double)seconds {
    
    //    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];
    //    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}


+ (NSString *)month:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)day:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)hour:(double)millisecond {
    
    millisecond /= 1000;
//    NSTimeZone * timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
//    [formatter setDateFormat:@"MMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond];
//    NSLog(@"date1:%@",date);
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)year_month_day_week:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
    NSArray * weekArray = @[ @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六" ];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday]-1;
//    int year=[comps year];
//    int month = [comps month];
//    int day = [comps day];

    NSString * dateStr = [formatter stringFromDate:date];
    NSString * weekStr = weekArray[week];
    NSString * str = [NSString stringWithFormat:@"%@ %@",dateStr,weekStr];
    return str;
}

+ (NSString *)week:(double)secondInterval {
    
    // 如果单位判断为毫秒则转换为秒
    if (secondInterval > 100000000000) {
        secondInterval /= 1000;
    }
    
    NSArray * weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInterval];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday]-1;
    NSString * weekStr = weekArray[week];
    NSString * str = [NSString stringWithFormat:@"%@",weekStr];
    return str;
}

+ (NSString *)getCurTime {
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSLog(@"%f",a);
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

+ (NSString *)getCurday_month_year {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * cur = [formatter stringFromDate:dat];
    return cur;
}

+ (NSString *)getCurday_month_yearWithformatStr:(NSString *)formatStr {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString * cur = [formatter stringFromDate:dat];
    return cur;
}

+ (NSString *)getCurday_month_year:(NSDate *)date {
    
  
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
  [formatter setTimeZone:timeZone];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  [formatter setDateFormat:@"YYYY-MM-dd"];
  NSString * cur = [formatter stringFromDate:date];
  return cur;
}

+ (NSString *)getCurhour_day_month:(NSDate *)date {
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString * cur = [formatter stringFromDate:date];
    return cur;
}


+ (int)getTheHourNum:(NSString *)beginDay endDay:(NSString *)endDay {
    
    NSString *startDateString = beginDay;
    NSString *endDateString=[NSString stringWithFormat:@"%@",endDay];
    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
    [inputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 将NSString转换为NSDate
    NSDate *startDate  = [inputFormat dateFromString:startDateString];
    NSDate *endDate  = [inputFormat dateFromString:endDateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    int hours = (int)[comps hour];
    return hours;
}

+ (int)getDayNumFromNowWithEndTime:(NSString *)endTime {
    
    int days = (int)[self getNotAbsDayNumFromNowWithEndTime:endTime];
    
    return abs(days);
}

+ (int)getNotAbsDayNumFromNowWithEndTime:(NSString *)endTime {
    
    double sec = [endTime doubleValue];
    
    // 如果单位判断为毫秒则转换为秒
    if (endTime.length >= 13) {
        sec /= 1000;
    }
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *nowDate  = [NSDate date];
    NSTimeInterval nowSec = [nowDate timeIntervalSince1970];
    
    NSInteger seconds = [zone secondsFromGMTForDate:nowDate];
//    NSLog(@"seconds = %lu", seconds);
    
    nowDate = [nowDate dateByAddingTimeInterval:seconds];
//    NSLog(@"nowDate = %@", nowDate);
    
    NSTimeInterval _interval = sec;
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSInteger localseconds = [zone secondsFromGMTForDate:localDate];
//    NSLog(@"seconds = %lu", localseconds);
    
    localDate = [localDate dateByAddingTimeInterval:localseconds];
//    NSLog(@"nowDate = %@", localDate);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate toDate:localDate options:NSCalendarWrapComponents];
    NSString * localStr = [self year_month_day_hour_minute_nian:[endTime doubleValue]];
    //    NSString * nowStr = [self dayForDate:nowDate];
    NSInteger daySec = 24 * 60 * 60;
    int days = (sec - nowSec)/daySec;
//    double cur = fmod((sec - nowSec),daySec);
//    NSInteger hourSec = 60*60;
//    int hours = cur/hourSec;
    NSString * nowHourStr = [self hourHH:nowSec * 1000];
    int hoursNow = [nowHourStr intValue];
    int hours = (int)[comps hour];
    int mins = (int)[comps minute];
    if (mins > 0) {
        hours += 1;
    }
//    else if(mins<0)
//    {
//        hours -= 1;
//    }
    if (days > 0) {
        if ((24 - hoursNow) <= hours) {
            days = days + 1;
        }
    } else if (days < 0) {
        if (hoursNow < abs(hours)) {
            days = days - 1;
        }
    } else {
        if (hours < 0) {
            if (hoursNow < abs(hours)) {
                days = days - 1;
            }
        }else{
            if ((24 - hoursNow) <= hours) {
                days = days + 1;
            }
        }
    }
    NSLog(@"今天距离%@差%d天:", localStr, days);
    return days;
}

+ (NSString *)hourHH:(double)millisecond {
    
    millisecond /= 1000;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}
/**
 2  * @method
 3  *
 4  * @brief 获取两个日期之间的天数
 5  * @param fromDate       起始日期
 6  * @param toDate         终止日期
 7  * @return    总天数
 8  */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --", comp);
    return comp.day;
}

+ (int)getHourNumFromNowWithEndTime:(NSString *)endTime {
    
//    NSString *endDateString = [NSString stringWithFormat:@"%@",endTime];
    
    double sec = [endTime doubleValue];
    if (endTime.length == 13) {
        sec = sec / 1000;
    }
    
//    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
//    [inputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将NSString转换为NSDate
    NSDate *nowDate  = [NSDate date];
    NSDate *endDate  = [NSDate dateWithTimeIntervalSince1970:sec];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:endDate toDate:nowDate options:0];
    int hours = (int)[comps hour];
    return abs(hours);
}

+ (int)getMinuteNumFromNowWithEndTime:(NSString *)endTime {
    
//    NSString *endDateString = [NSString stringWithFormat:@"%@",endTime];
    
    double sec = [endTime doubleValue];
    if (endTime.length == 13) {
        sec = sec / 1000;
    }
    
//    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
//    [inputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将NSString转换为NSDate
    NSDate *nowDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:sec];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitMinute;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:endDate toDate:nowDate options:0];
    int minutes = (int)[comps minute];
    return abs(minutes);
}

+ (int)getSecondNumFromNowWithEndTime:(NSString *)endTime {
    
//    NSString *endDateString = [NSString stringWithFormat:@"%@", endTime];
    
    double sec = [endTime doubleValue];
    if (endTime.length >= 13) {
        sec = sec / 1000;
    }
    
//    NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
//    [inputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将NSString转换为NSDate
    NSDate *nowDate  = [NSDate date];
    NSDate *endDate  = [NSDate dateWithTimeIntervalSince1970:sec];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitSecond;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:endDate toDate:nowDate options:0];
    int minutes = (int)[comps second];
    return abs(minutes);
}


+ (int)compareNowWithDate:(NSString *)secDate {
    
    double endDateSec = [secDate doubleValue];
    double nowDateSec = [[NSDate date] timeIntervalSince1970];
    return endDateSec-nowDateSec;
}

+ (NSMutableDictionary *)dayWithDays:(int)days formatterStr:(NSString *)formatterStr {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitDay ) fromDate:[[NSDate alloc] init]];
    
    [components setDay:days];
    NSDate *today = [NSDate date];
    NSDate *newDay = [cal dateByAddingComponents:components toDate: today options:0];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr];
    NSString * dayStr = [formatter stringFromDate:newDay];
    
    NSArray * weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:newDay];
    int week = (int)[comps weekday]-1;
    NSString * weekStr = weekArray[week];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"day"] = dayStr;
    dic[@"week"] = weekStr;
    return dic;
}


+ (NSString *)currentDurationString:(NSInteger)duration {
    
    NSInteger h = duration / 3600;
    NSInteger m = (duration % 3600) / 60;
    NSInteger s = duration % 60;
    if (h <= 0) {
        return [NSString stringWithFormat:@"%ld分%ld秒", (long)m, (long)s];
    } else if (m <= 0)
    {
        return [NSString stringWithFormat:@"%ld秒", (long)s];
    } else {
        
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒", (long)h, (long)m, (long)s];
    }
    
    return @"";
}

+ (NSString *)formatDurationString:(double)second {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
