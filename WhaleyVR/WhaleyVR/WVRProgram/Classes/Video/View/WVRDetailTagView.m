//
//  WVRDetailTagView.m
//  VRManager
//
//  Created by Snailvr on 16/6/17.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 视频详情页面的标签

#import "WVRDetailTagView.h"
#import "WVRUIEngine.h"

@interface WVRDetailTagView () {
    
    float spaceY;
    float lenX;
}

@property (nonatomic, weak) UILabel *areaLabel;
@property (nonatomic, weak) UILabel *yearLabel;
@property (nonatomic, weak) UILabel *directorLabel;
@property (nonatomic, weak) UILabel *castLabel;

@end


@implementation WVRDetailTagView

- (instancetype)initWithModel:(WVRVideoDetailVCModel *)model {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        spaceY = adaptToWidth(8);
        lenX = adaptToWidth(15);
        
        NSString *str = [NSString stringWithFormat:@"地区：%@", (model.area.length > 0) ? model.area : @"无"];
        NSAttributedString *attStr = [WVRUIEngine descStringWithString:str];
        
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(lenX, 0, SCREEN_WIDTH/2.0 - lenX, 20)];
        areaLabel.attributedText = attStr;
        [areaLabel sizeToFit];
        
        [self addSubview:areaLabel];
        _areaLabel = areaLabel;
        
        str = [NSString stringWithFormat:@"年代：%@", (model.age.length > 0) ? model.age : @"无"];
        attStr = [WVRUIEngine descStringWithString:str];
        
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0 - lenX, 20)];
        yearLabel.attributedText = attStr;
        [yearLabel sizeToFit];
        
        [self addSubview:yearLabel];
        _yearLabel = yearLabel;
        
        str = [NSString stringWithFormat:@"导演：%@", model.director];
        attStr = [WVRUIEngine descStringWithString:str];
        
        UILabel *directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(lenX, areaLabel.bottomY + spaceY, SCREEN_WIDTH - 2*lenX, 20)];
        directorLabel.numberOfLines = 0;
        directorLabel.attributedText = attStr;
        directorLabel.size = [WVRComputeTool sizeOfString:attStr Size:CGSizeMake(SCREEN_WIDTH - 2*lenX, 0)];
        
        [self addSubview:directorLabel];
        _directorLabel = directorLabel;
        
        str = [NSString stringWithFormat:@"主演：%@", model.actors];
        attStr = [WVRUIEngine descStringWithString:str];
        
        UILabel *castLabel = [[UILabel alloc] initWithFrame:CGRectMake(lenX, directorLabel.bottomY + spaceY, SCREEN_WIDTH - 2*lenX, 20)];
        castLabel.numberOfLines = 0;
        castLabel.attributedText = attStr;
        castLabel.size = [WVRComputeTool sizeOfString:attStr Size:CGSizeMake(SCREEN_WIDTH - 2*lenX, 0)];
        
        [self addSubview:castLabel];
        _castLabel = castLabel;
        
        self.height = castLabel.bottomY;
    }
    return self;
}

- (void)fillInfoWithModel:(WVRVideoDetailVCModel *)model {
    
    NSString *str = [NSString stringWithFormat:@"地区：%@", (model.area.length > 0) ? model.area : @"无"];
    NSAttributedString *attStr = [WVRUIEngine descStringWithString:str];
    
    _areaLabel.attributedText = attStr;
    [_areaLabel sizeToFit];
    
    
    str = [NSString stringWithFormat:@"年代：%@", (model.age.length > 0) ? model.age : @"无"];
    attStr = [WVRUIEngine descStringWithString:str];
    
    _yearLabel.attributedText = attStr;
    [_yearLabel sizeToFit];
    
    
    str = [NSString stringWithFormat:@"导演：%@", model.director];
    attStr = [WVRUIEngine descStringWithString:str];
    
    _directorLabel.attributedText = attStr;
    _directorLabel.size = [WVRComputeTool sizeOfString:attStr Size:CGSizeMake(SCREEN_WIDTH - 2*lenX, 0)];
    
    str = [NSString stringWithFormat:@"主演：%@", model.actors];
    attStr = [WVRUIEngine descStringWithString:str];
    
    
    _castLabel.attributedText = attStr;
    _castLabel.size = [WVRComputeTool sizeOfString:attStr Size:CGSizeMake(SCREEN_WIDTH - 2*lenX, 0)];
    
    self.height = _castLabel.bottomY;
}


// 添加、
+ (NSString *)arrayToString:(NSArray *)array {
    
    if (array.count < 1) {
        return @"无";
    }
    
    if (array.count == 1) {
        
        NSString *tmp = [array firstObject];
        if (tmp.length < 1) {
            return @"无";
        }
    }
    
    NSMutableString *mutableStr = [NSMutableString string];
    
    int i = 1;
    for (NSString *str in array) {
        
        [mutableStr appendString:str];
        
        if (array.count > i) {
            [mutableStr appendString:@"、"];
            i += 1;
        }
    }
    
    return [mutableStr copy];
}

// 添加；
+ (NSString *)arrayToStr:(NSArray *)array {
    
    if (array.count < 1) {
        return @"无";
    }
    
    if (array.count == 1) {
        
        NSString *tmp = [array firstObject];
        if (tmp.length < 1) {
            return @"无";
        }
    }
    
    NSMutableString *mutableStr = [NSMutableString string];
    
    int i = 1;
    for (NSString *str in array) {
        
        [mutableStr appendString:str];
        
        if (array.count > i) {
            [mutableStr appendString:@"；"];
            i += 1;
        }
    }
    
    return [mutableStr copy];
}

@end
