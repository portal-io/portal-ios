//
//  WVRSQFindMoreBrandModel.h
//  WhaleyVR
//
//  Created by qbshen on 16/11/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRBaseModel.h"
#import "WVRSectionModel.h"

@interface WVRBrandZoneVCModel : WVRBaseModel
@property (nonatomic) WVRSectionModel * sectionModel;

-(void)http_recommendPageWithCode:(NSString*)code successBlock:(void(^)(WVRSectionModel*))successBlock failBlock:(void(^)(NSString*))failBlock;
-(void)http_recommendPageMoreWithCode:(NSString*)code successBlock:(void(^)(WVRSectionModel*))successBlock failBlock:(void(^)(NSString*))failBlock;
@end
