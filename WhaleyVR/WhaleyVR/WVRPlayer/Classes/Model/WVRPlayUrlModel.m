//
//  WVRPlayUrlModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/4/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayUrlModel.h"
#import "WVRParserUrlResult.h"
#import "WVRVideoParamEntity.h"

@implementation WVRPlayUrlModel

- (instancetype)initWithElement:(WVRParserUrlElement *)element {
    self = [super init];
    if (self) {
        // protect
        if (nil == element.url || nil == element.definition) { return nil; }
        
        _definition = element.definition;
        _url = element.url;
        _defiType = element.defiType;
    }
    return self;
}

- (void)setDefinition:(NSString *)definition {
    _definition = definition;
    
    _defiType = [WVRVideoParamEntity definitionToType:definition];
}

- (NSString *)cameraStand {
    
    return _cameraStand ?: kDefault_Camera_Stand;
}

@end
