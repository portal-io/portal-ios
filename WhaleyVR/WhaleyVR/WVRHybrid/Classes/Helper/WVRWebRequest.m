//
//  WVRWebRequest.m
//  JockeyJS
//
//  Created by Wang Tiger on 16/10/21.
//  Copyright © 2016年 Corkboardme. All rights reserved.
//

#import "WVRWebRequest.h"
#import "WVRAppContextHeader.h"
#import "NSDictionary+Extension.h"
//#import "WVRApiHttpVRAPIAuth.h"

@implementation WVRWebRequest

+ (void)authWeb:(id)params successBlock:(void(^)(NSString *responseObj, NSError *error))block {
    
//    WVRApiHttpVRAPIAuth *api = [[WVRApiHttpVRAPIAuth alloc] init];
//    api.bodyParams = params;
//    api.successedBlock = ^(id data) {
//        NSString *obj = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        block(obj, nil);
//    };
//    api.failedBlock = ^(WVRNetworkingResponse *error) {
//        NSLog(@"%@", [error contentString]);
//        block(nil, [[NSError alloc] init]);
////        NSString *obj = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////        block(obj, nil);
//    };
//    [api loadData];
}

+ (void)executeRequest:(NSString *)func URL:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block {
    
    if ([func isEqualToString:@"POST"]) {
        [self authWeb:params successBlock:^(NSString *responseObj, NSError *error) {
            block(responseObj, error);
        }];
//        [WVRWebRequest POSTService:URLStr withParams:params completionBlock:^(NSString *responseObj, NSError *error) {
//            
//            block(responseObj, error);
//        }];
        
    } else if ([func isEqualToString:@"GET"]) {
        
        [WVRWebRequest GETService:URLStr withParams:params completionBlock:^(NSString *responseObj, NSError *error) {
            
            block(responseObj, error);
        }];
    } else {
        DebugLog(@"参数错误！！！");
    }
}

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block {
    
    NSString *urlString = URLStr;
    if (params.count > 0) {
        NSString *appendString = [params parseGETParams];
        urlString = [NSString stringWithFormat:@"%@?%@", URLStr, appendString];
    }
    
    NSLog(@"URLString = %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            block(nil, error);
            
        } else {
            
            NSString *obj = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            block(obj, nil);
        }
    }];
    
    [sessionDataTask resume];
}


+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(void(^)(NSString *responseObj, NSError *error))block {
    
    NSURL *url = [NSURL URLWithString:[URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    if (params.count > 0) {
        
        NSData *postData = [params parsePOSTParams];
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            block(nil, error);
            
        } else {
            
            NSString *obj = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            block(obj, nil);
        }
    }];
    
    [sessionDataTask resume];
}


@end
