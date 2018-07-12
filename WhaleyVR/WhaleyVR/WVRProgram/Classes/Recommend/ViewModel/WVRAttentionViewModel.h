//
//  WVRAttentionViewModel.h
//  WVRProgram
//
//  Created by Bruce on 2017/9/15.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRAttentionModel.h"

@interface WVRAttentionViewModel : WVRViewModel

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) WVRAttentionModel *attentionModel; 

- (RACCommand *)httpCmd;

@end
