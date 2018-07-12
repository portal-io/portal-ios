//
//  WVRApiHttpRegister.h
//  WhaleyVR
//
//  Created by XIN on 17/03/2017.
//  Copyright © 2017 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

extern NSString * const kHttpParams_collectionSave_userLoginId ;
extern NSString * const kHttpParams_collectionSave_userName ;
extern NSString * const kHttpParams_collectionSave_programCode ;
extern NSString * const kHttpParams_collectionSave_programName ;
extern NSString * const kHttpParams_collectionSave_videoType ;

extern NSString * const kHttpParams_collectionSave_programType ;
extern NSString * const kHttpParams_collectionSave_status ;
extern NSString * const kHttpParams_collectionSave_duration ;
extern NSString * const kHttpParams_collectionSave_picUrl ;

@interface WVRApiHttpCollectionSave : WVRAPIBaseManager <WVRAPIManager>

@end
