//
//  WVRRequestClient.m
//  WhaleyVR
//
//  Created by Snailvr on 16/9/23.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 普通网络请求类 为了解决播放次数上传接口问题

#import "WVRRequestClient.h"
#import <AFNetworking.h>
#import "WVRAPIHandle.h"

@interface WVRRequestClient ()<NSURLSessionDataDelegate>

@end


@implementation WVRRequestClient

+ (void)GETService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSString *urlString = URLStr;
    NSDictionary *dict = [WVRAPIHandle appendCommenParams:params];
    
    NSString *appendString = [dict parseGETParams];
    urlString = [NSString stringWithFormat:@"%@?%@", URLStr, appendString];
    
    DDLogInfo(@"WVRRequestClient_GET %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                DDLogError(@"WVRRequestClient_GET %@", request.URL.absoluteString);
                DDLogError(@"WVRRequestClient_GET %@", [error localizedDescription]);
                
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                DDLogError(@"WVRRequestClient_GET %ld", (long)res.statusCode);
                
                block(nil, error);
            } else {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                block(dict, nil);
            }
        });
    }];
    
    [sessionDataTask resume];
}


+ (void)POSTService:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    NSURL *url = [NSURL URLWithString:[URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    DDLogInfo(@"WVRRequestClient_POST %@ \nparams: %@", URLStr, params);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dict = [WVRAPIHandle appendCommenParams:params];
    if (dict.count > 0) {
        
        NSData *postData = [dict parsePOSTParams];
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                DDLogError(@"WVRRequestClient_GET %@", request.URL.absoluteString);
                DDLogError(@"WVRRequestClient_GET %@", [error localizedDescription]);
                
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                DDLogError(@"WVRRequestClient_GET %ld", (long)res.statusCode);
                
                block(nil, error);
            } else {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                block(dict, nil);
            }
        });
    }];
    
    [sessionDataTask resume];
}

+ (void)POSTFormData:(NSString *)URLStr withParams:(NSDictionary *)params completionBlock:(APIResponseBlock)block {
    
    DDLogInfo(@"WVRRequestClient_POSTForm %@ \nparams: %@", URLStr, params);
    NSDictionary *dict = [WVRAPIHandle appendCommenParams:params];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key in dict.allKeys) {
            [formData appendPartWithFormData:[dict[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }
        
    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          
                          DDLogError(@"WVRRequestClient_POSTForm %@", request.URL.absoluteString);
                          DDLogError(@"WVRRequestClient_POSTForm %@", [error localizedDescription]);
                          
                          NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                          DDLogError(@"WVRRequestClient_POSTForm %ld", (long)res.statusCode);
                          
                          block(nil, error);
                      } else {
                          block(responseObject, nil);
                      }
                  }];
    
    [uploadTask resume];
}

@end
