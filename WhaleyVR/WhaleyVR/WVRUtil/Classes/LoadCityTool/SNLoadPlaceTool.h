//
//  SNLoadCityTool.h
//  soccernotes
//
//  Created by sqb on 15/11/2.
//  Copyright © 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NAME_DB ;

@interface SNBasePlaceInfo: NSObject

@property (nonatomic) NSString * uuid;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * firstLetter;

@end


@interface SNCountyInfo: SNBasePlaceInfo

@property (nonatomic) NSString * coid;
@property (nonatomic) NSString * cityID;

@end


@interface SNCityInfo: SNBasePlaceInfo

@property (nonatomic) NSString * cid;
@property (nonatomic) NSString * provinceID;

@end


@interface SNProvinceInfo: SNBasePlaceInfo

@property (nonatomic) NSString * pid;
@property NSMutableArray * citys;

@end


@interface SNSchoolInfo: SNBasePlaceInfo

@property (nonatomic) NSString * coid;
@property (nonatomic) NSString * provinceID;

@end


@interface SNMajorInfo: SNBasePlaceInfo

@property (nonatomic) NSString * coid;
@property (nonatomic) NSString * provinceID;

@end


@interface SNCollegeInfo: SNBasePlaceInfo

@property (nonatomic) NSString * coid;
@property (nonatomic) NSString * provinceID;

@end


@interface SNLoadPlaceTool : NSObject

+ (NSDictionary *)loadLetterDicForCity;
+ (NSDictionary *)loadLetterDicForProvince;
+ (NSArray<SNProvinceInfo *> *)loadLetterArrayForProvince;
+ (NSArray<SNCountyInfo *> *)loadCountyArrayForCity:(NSString *)cityId;
+ (NSArray<SNCityInfo *> *)loadCityArrayForProvince:(NSString *)provinceID;
+ (NSArray *)loadSchoolArrayForProvince:(NSString *)provinceID;
+ (NSArray *)likeSearchMajorData:(NSString *)searchKey;
+ (NSArray *)loadMajorData;
+ (SNProvinceInfo*)searchProviceData:(NSString *)proviceName;
+ (SNCityInfo*)searchCityData:(NSString *)cityName;
+ (NSArray *)searchCollegeData:(NSString *)universityID;
+ (NSArray *)likeSearchCollegeData:(NSString *)searchKey anduniversityID:(NSString *)universityID;
+ (NSArray *)likeSearchUniData:(NSString *)searchKey provinceID:(NSString *)provinceID;

@end
