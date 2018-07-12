//
//  WVRMediaDto.m
//  WhaleyVR
//
//  Created by Bruce on 2017/7/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediaDto.h"

@implementation WVRMediaDto
@synthesize curDefinition = _curDefinition;

- (NSArray *)modelPropertyBlacklist {
    
    return @[ @"curDefinition" ];
}

#pragma mark - getter

- (NSString *)curDefinition {
    
    if (!_curDefinition) {
        
        NSString *str = [self.resolution uppercaseString];
        
        if ([str isEqualToString:@"4K"]) {
            _curDefinition = @"HD";
        } else if ([str isEqualToString:@"8P"]) {
            _curDefinition = @"SD";
        } else {
            _curDefinition = @"ST";
        }
    }
    
    return _curDefinition;
}

@end

