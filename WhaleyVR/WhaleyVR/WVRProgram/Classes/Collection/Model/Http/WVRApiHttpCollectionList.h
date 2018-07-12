//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"
#import <UIKit/UIKit.h>

extern NSString * const kHttpParams_collectionGet_userLoginId ;
extern NSString * const kHttpParams_collectionGet_page ;
extern NSString * const kHttpParams_collectionGet_size ;


@interface WVRApiHttpCollectionList : WVRAPIBaseManager <WVRAPIManager>

@end
