//
//  WVRHttpUserAuthReformer.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/11.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRHttpUserAuthReformer.h"
#import "WVRAuthModel.h"

@implementation WVRHttpUserAuthReformer
- (id)reformData:(NSDictionary *)data {
    NSNumber * statusCodeNumber = data[@"status"];
    NSString * statusCode = [NSString stringWithFormat:@"%@",statusCodeNumber];
    NSDictionary * userDic = data[@"memberdata"];
    NSString * uid = userDic[@"uid"];
    WVRAuthModel * authedModel = [WVRAuthModel new];
    authedModel.statusCode = statusCode;
    authedModel.authedUid = uid;
    return authedModel;
}
@end
