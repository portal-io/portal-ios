//
//  UnityAppController+Extend.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/28.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "UnityAppController.h"
//#import <JSPatchPlatform/JSPatch.h>
#import "SQCocoaHttpServerTool.h"
#import "HttpAgent.h"

@interface UnityAppController (Extend)

- (void)configureThirdFrameworks;

- (void)reportEnterApp;

- (void)playerParserInit;
@end
