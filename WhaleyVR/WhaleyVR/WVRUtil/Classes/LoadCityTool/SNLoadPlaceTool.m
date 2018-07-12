//
//  SNLoadCityTool.m
//  soccernotes
//
//  Created by sqb on 15/11/2.
//  Copyright © 2015年 sqp. All rights reserved.
//

#import "SNLoadPlaceTool.h"
#import "FMDatabase.h"
#import "HTFirstLetter.h"

NSString * const NAME_DB = @"nation.db";

@interface SNLoadPlaceTool ()

@property NSMutableDictionary * letterDic;
@property NSArray * mDataArray;

@end


@implementation SNLoadPlaceTool

+ (NSDictionary*)loadLetterDicForCity
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    tool.mDataArray = [tool loadCityData];
    [tool initLetterDic];
    return tool.letterDic;
}

+ (NSDictionary*)loadLetterDicForProvince
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    tool.mDataArray = [tool loadProvinceData];
    [tool initLetterDic];
    return tool.letterDic;
}

+ (NSArray *)loadLetterArrayForProvince
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    return [tool loadProvinceData];
}

+ (NSArray *)loadCityArrayForProvince:(NSString *)provinceID
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    return [tool loadCityDataForProvinceID:provinceID];
}

+ (NSArray *)loadCountyArrayForCity:(NSString *)cityId
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    return [tool loadCountyDataForCityID:cityId];
}

+ (NSArray *)loadSchoolArrayForProvince:(NSString *)provinceID
{
    SNLoadPlaceTool * tool = [SNLoadPlaceTool new];
    return [tool loadSchoolDataForProvinceID:provinceID];
}

- (void)initLetterDic
{
    if (nil == self.letterDic) {
        self.letterDic = [NSMutableDictionary dictionary];
        for(int index = 0; index < 26; index ++){
            int n = 65;//60是ascii码
            int thumN = 97;
            char c = (char)(n+index);//ascii码转换成字符
            char c_thum = (char)(thumN+index);//ascii码转换成字符
            NSString * bigKeyStr = [NSString stringWithFormat:@"%c",c];
            NSString * thumKeyStr = [NSString stringWithFormat:@"%c",c_thum];
            
            [self.letterDic setValue:[self filterPlaceByLetter:thumKeyStr] forKey:bigKeyStr];
        }
    }
}

- (NSArray *)filterPlaceByLetter:(NSString *)letter
{
    NSMutableArray * curArray = [NSMutableArray array];
    
    for (SNBasePlaceInfo * cur in [self mDataArray]) {
        //        const char * utfString = [cur.cityName UTF8String];
        //        unsigned short u = atoi(utfString);
        char letterChar = pinyinFirstLetter([cur.name characterAtIndex:0]);
        //        NSLog(@"%c",letterChar);
        NSString * letterStr = [NSString stringWithFormat:@"%c",letterChar];
        if ([letterStr isEqualToString:letter]) {
            cur.firstLetter = letterStr;
            [curArray addObject:cur];
        }
    }
    return [curArray mutableCopy];
}

- (NSArray *)loadCityData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_city"];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"C_CityID"];
        NSString * cityName = [rs stringForColumn:@"C_Name"];
//        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"C_ProvinceID"];
        SNCityInfo * cityInfo = [SNCityInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
//        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

- (NSArray *)loadCountyDataForCityID:(NSString *)cityID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM County where city_id=%@",cityID]];
    while ([rs next]) {
        NSString *countyID = [rs stringForColumn:@"id"];
        NSString * countyName = [rs stringForColumn:@"name"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        SNCountyInfo * cityInfo = [SNCountyInfo new];
        cityInfo.uuid = countyID;
        cityInfo.name = countyName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.cityID = cityID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

- (NSArray *)loadCityDataForProvinceID:(NSString *)provinceID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM City where province_id=%@",provinceID]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"id"];
        NSString * cityName = [rs stringForColumn:@"name"];
//        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        SNCityInfo * cityInfo = [SNCityInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
//        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

- (NSArray *)loadProvinceData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM Province"];// order by ProvinceID ASC
    while ([rs next]) {
        NSString *provinceID = [rs stringForColumn:@"id"];
        NSString * provinceName = [rs stringForColumn:@"name"];
        SNProvinceInfo * provinceInfo = [SNProvinceInfo new];
        provinceInfo.uuid = provinceID;
        provinceInfo.name = provinceName;
        [data addObject:provinceInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}


- (NSArray *)loadSchoolDataForProvinceID:(NSString *)provinceID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_area_university where AU_Area=%@",provinceID]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"AU_UniversityID"];
        NSString * cityName = [rs stringForColumn:@"AU_University"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"AU_Area"];
        SNSchoolInfo * cityInfo = [SNSchoolInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}


+ (NSArray *)loadMajorData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_university_major"]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"UM_ID"];
        NSString * cityName = [rs stringForColumn:@"UM_Major"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"UM_UniversityID"];
        SNSchoolInfo * cityInfo = [SNSchoolInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

+ (NSArray *)likeSearchMajorData:(NSString *)searchKey
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_university_major where UM_Major like %@%@%@",@"'%",searchKey,@"%'"]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"UM_ID"];
        NSString * cityName = [rs stringForColumn:@"UM_Major"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"UM_UniversityID"];
        SNSchoolInfo * cityInfo = [SNSchoolInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

+ (SNProvinceInfo*)searchProviceData:(NSString *)proviceName
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Province where name=%@%@%@",@"'",proviceName,@"'"]];
    while ([rs next]) {
        NSString *proviceID = [rs stringForColumn:@"id"];
        NSString * proviceName = [rs stringForColumn:@"name"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        SNProvinceInfo * proviceInfo = [SNProvinceInfo new];
        proviceInfo.uuid = proviceID;
        proviceInfo.name = proviceName;
        //        cityInfo.zipCode = zipCode;
        [data addObject:proviceInfo];
    }
    [rs close];
    [db close];
    return [data firstObject];
}

+ (SNProvinceInfo*)searchCityData:(NSString *)cityName
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM City where name=%@%@%@",@"'",cityName,@"'"]];
    while ([rs next]) {
        NSString *proviceID = [rs stringForColumn:@"id"];
        NSString * proviceName = [rs stringForColumn:@"name"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        SNCityInfo * proviceInfo = [SNCityInfo new];
        proviceInfo.uuid = proviceID;
        proviceInfo.name = proviceName;
        //        cityInfo.zipCode = zipCode;
        [data addObject:proviceInfo];
    }
    [rs close];
    [db close];
    return [data firstObject];
}

+ (NSArray *)searchCollegeData:(NSString *)universityID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_university_college where UC_UniversityID=%@",universityID]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"UC_CollegeID"];
        NSString * cityName = [rs stringForColumn:@"UC_CollegeName"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"UC_UniversityID"];
        SNCollegeInfo * cityInfo = [SNCollegeInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

+ (NSArray *)likeSearchCollegeData:(NSString *)searchKey anduniversityID:(NSString *)universityID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_university_college where UC_UniversityID=%@ and UC_CollegeName like %@%@%@",universityID,@"'%",searchKey,@"%'"]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"UC_CollegeID"];
        NSString * cityName = [rs stringForColumn:@"UC_CollegeName"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"UM_UniversityID"];
        SNSchoolInfo * cityInfo = [SNSchoolInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}

+ (NSArray *)likeSearchUniData:(NSString *)searchKey provinceID:(NSString *)provinceID
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME_DB];
    NSLog(@"db path is %@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM t_area_university where AU_Area=%@ and AU_University like %@%@%@",provinceID,@"'%",searchKey,@"%'"]];
    while ([rs next]) {
        NSString *cityID = [rs stringForColumn:@"AU_UniversityID"];
        NSString * cityName = [rs stringForColumn:@"AU_University"];
        //        NSString *zipCode = [rs stringForColumn:@"ZipCode"];
        NSString * provinceID = [rs stringForColumn:@"AU_Area"];
        SNSchoolInfo * cityInfo = [SNSchoolInfo new];
        cityInfo.uuid = cityID;
        cityInfo.name = cityName;
        //        cityInfo.zipCode = zipCode;
        cityInfo.provinceID = provinceID;
        [data addObject:cityInfo];
    }
    [rs close];
    [db close];
    return [data mutableCopy];
}
@end
@implementation SNBasePlaceInfo

@end
@implementation SNCityInfo

@end
@implementation SNProvinceInfo

@end
@implementation SNSchoolInfo

@end
@implementation SNMajorInfo

@end
@implementation SNCollegeInfo

@end
@implementation SNCountyInfo


@end
