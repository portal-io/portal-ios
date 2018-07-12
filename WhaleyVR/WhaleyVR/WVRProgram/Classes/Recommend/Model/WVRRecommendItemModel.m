//
//  WVRRecommendItemModel.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRRecommendItemModel.h"

@implementation WVRRecommendItemModel

#pragma mark - property map

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"picUrl_" : @"newPicUrl" };
}

- (NSString *)playUrl {
    
    return _videoUrl;
}

// 资讯比较特殊
- (NSString *)sid {
    if (self.linkArrangeValue.length) {
        return self.linkArrangeValue;
    }
    if (self.infUrl.length) {
        return self.infUrl;
    }
    if (self.code) {
        return self.code;
    }
    return nil;
}

@end


@implementation WVRStatQueryDto

// 请求视频统计信息
+ (void)requestWithCode:(NSString *)code block:(void(^)(WVRStatQueryDto * responseObj, NSError *error))block {
    
    if (nil == code) {
        
        DDLogError(@"[WVRStatQueryDto requestWithCode:] - code can't be nil");
        return;
    }
    
    NSString *urlSufix = @"stat/findBySrcCode";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAPI_SERVICE, urlSufix];
    NSDictionary *dict = @{ @"srcCode" : code };
    
    [WVRWhaleyHTTPManager GETService:urlStr withParams:dict completionBlock:^(id responseObj, NSError *error) {
        
        if (error) {
            block(nil, error);
            return;
        }
        
        NSDictionary *dict = responseObj;
        NSDictionary *dataDic = dict[@"data"];
        
        WVRStatQueryDto *model = [WVRStatQueryDto yy_modelWithDictionary:dataDic];
        
        block(model, nil);
    }];
}

@end
