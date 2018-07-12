//
//  DTPCreateKeyHeader.h
//  DTPocket
//
//  Created by sqb on 15/4/10.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#ifndef soccernotes_SNUtilToolHeader_h
#define soccernotes_SNUtilToolHeader_h

#import "SQMD5Tool.h"
/*
 create key with num
 */
#define KEY_WITH_NUM(NUM) ( {[NSString stringWithFormat:@"%ld",(long)NUM];})

/*
 get cell with nibName
 */
#define CELL_WITH_NIB(tableView,reuseId,nibName) ({ UINib * nib = [UINib nibWithNibName:nibName bundle:nil];    [tableView registerNib:nib forCellReuseIdentifier:reuseId];     [tableView dequeueReusableCellWithIdentifier:reuseId ];})

/*
 get view with nibName
 */
#define VIEW_WITH_NIB(nibName) ({ UIView * view = nil; NSArray *nib = [[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];if ([nib count]>0) {    view = [nib objectAtIndex:0];}else{    view = nil;} view;})
/*
 get date with date format(@"yyyy-MM-dd")
 */
#define STR_DATE_FROM_DATE(date) ({NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];[dateFormatter setDateFormat:@"yyyy-MM-dd"];NSString *destDateString = [dateFormatter stringFromDate:date]; destDateString;})

/*
 get time with date format(@"HH:mm")
 */

#define STR_TIME_FROM_DATE(date) ({NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];[dateFormatter setDateFormat:@"HH:mm"];NSString *destDateString = [dateFormatter stringFromDate:date]; destDateString;})

/*
 get date with date format(@"yyyy-MM-dd HH:mm")
 */
#define STR_DATE_TIME_FROM_DATE(date) ({NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];NSString *destDateString = [dateFormatter stringFromDate:date]; destDateString;})

#endif
