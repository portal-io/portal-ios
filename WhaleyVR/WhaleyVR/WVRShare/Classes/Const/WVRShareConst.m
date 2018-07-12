//
//  WVRShareConst.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/2.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShareConst.h"
#import <WVRAppDefine.h>
#import <WVRUserModel.h>

@implementation WVRShareConst

+ (NSString *)share_baseUrl {
    
#if (kAppEnvironmentTest == 1)
    if ([[WVRUserModel sharedInstance] isTest]) {
        return @"http://vrh5.test.moguv.com/app-share-h5/";//@"http://minisite.test.snailvr.com/whaleyTopic/newvoicev2/";
    }
#endif
    return @"http://vrh5.moguv.com/app-share-h5/";//@"http://minisite-c.snailvr.com/whaleyTopic/newvoicev2/";
}

+ (NSString *)shareVideoDetailsUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"viewthread.html?code="];
}

+ (NSString *)share3DMovieDetailsUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"viewthread3D.html?code="];
}

+ (NSString *)shareSpecialTopicDetailsUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"topic.html?code="];
}

+ (NSString *)shareLiveUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"liveProgram.html?code="];
}

+ (NSString *)shareSpecialTopicUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"index.html?code="];
}

+ (NSString *)share2018SpringTopicUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"springFestival2018.html?code="];
}

+ (NSString *)shareSpecialProgramPackageUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"itempack.html?code="];
}

+ (NSString *)shareSpecialMoreTVUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"tv.html?code="];
}

+ (NSString *)shareInteractionDramaUrl {
    NSString *baseUrl = [self share_baseUrl];
    
    return [baseUrl stringByAppendingString:@"dynaprogram.html?code="];
}

@end
