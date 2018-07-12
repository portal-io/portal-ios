//
//  WVRApiHttpHome.h
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIBaseManager.h"

UIKIT_EXTERN NSString * const kHttpParam_programPackage_code ;
UIKIT_EXTERN NSString * const kHttpParam_programPackage_size ;
UIKIT_EXTERN NSString * const kHttpParam_programPackage_page ;

@interface WVRHttpProgramPackage : WVRAPIBaseManager <WVRAPIManager>

@end
