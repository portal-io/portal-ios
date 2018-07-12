//
//  WVRVideoParamEntity.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/14.
//  Copyright © 2017年 Snailvr. All rights reserved.

// Player与Program解耦，本类是所有WVRVideoEntity的父类

#import "WVRVideoParamEntity.h"
#import "WVRUserModel.h"
#import "WVRParseUrl.h"
#import <SecurityFramework/Security.h>
#import "WVRAppContextHeader.h"
#import "NSURL+Extend.h"

NSString *const kDefault_Camera_Stand = @"0";
#define kFootballDefaultStand @"Public"

@interface WVRVideoParamEntity ()

@property (nonatomic, readonly) int currentUrlIndex;

@end


@implementation WVRVideoParamEntity

@synthesize currentUrlIndex = _currentUrlIndex;
@synthesize curDefinition = _tmpCurDefinition;
@synthesize curUrlModel = _tmpCurUrlModel;          // 若要使用请打点调用
@synthesize renderTypeStr = _tmpRenderTypeStr;
@synthesize parserdUrlModelDict = _parserdUrlModelDict;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _biEntity = [[WVRVideoBIEntity alloc] init];
    }
    
    return self;
}

#pragma mark - setter

//- (void)setSid:(NSString *)sid {
//    
//    _sid = sid ?: @"";
//}

- (void)setPlayUrls:(NSArray<NSString *> *)playUrls {
    
    _currentUrlIndex = 0;
    _playUrls = playUrls;
}

// 给当前model赋值的时候同时给当前清晰度赋值
- (void)setCurUrlModel:(WVRPlayUrlModel *)curUrlModel {
    
    _tmpCurUrlModel = curUrlModel;
    _tmpCurDefinition = curUrlModel.definition;
    _tmpRenderTypeStr = curUrlModel.renderType;
}

- (void)setParserdUrlModelDict:(NSDictionary<NSString *,NSDictionary<NSString *,WVRPlayUrlModel *> *> *)parserdUrlModelDict {
    
    _parserdUrlModelDict = parserdUrlModelDict;
}

#pragma mark - getter

- (BOOL)isCameraStandVIP {
    
    return ![self.currentStandType isEqualToString:kFootballDefaultStand];
}

- (WVRRenderType)renderTypeForFootballCurrentCameraStand {
    
    if ([self isCameraStandVIP]) {
        
        return MODE_HALF_SPHERE_VIP;
    }
    
    return [WVRVideoParamEntity renderTypeForRenderTypeStr:self.curUrlModel.renderType];
}

- (BOOL)isDefault_SD {
    for (WVRPlayUrlModel * model in [self.parserdUrlModelDict.allValues firstObject].allValues) {
        if ([model.definition isEqualToString:kDefinition_SD] || [model.definition isEqualToString:kDefinition_SDB]) {
            return [WVRUserModel sharedInstance].defaultDefinition == 1;
        }
    }
    if ([self.curUrlModel.definition isEqualToString:kDefinition_SD] || [self.curUrlModel.definition isEqualToString:kDefinition_SDB]) {
        return [WVRUserModel sharedInstance].defaultDefinition == 1;
    }
    return NO;
}

- (void)setDefault_SD:(BOOL)isSD {
    
    [[WVRUserModel sharedInstance] setDefaultDefinition:isSD ? 1 : 0];
}

- (BOOL)isDefaultVRMode {        // 是否默认分屏播放
    
    // MARK: - live and moreTV default is not VRMode
    if (self.streamType == STREAM_VR_LIVE || self.streamType == STREAM_2D_TV) { return NO; }
    
    BOOL isDefaultVR = NO;
    NSString *mode = [[WVRUserModel sharedInstance] playerMode];
    if ([mode isEqualToString:PLAYER_MODE_VR]) { isDefaultVR = YES; }
    
    return isDefaultVR;
}

- (void)setDefaultVRMode:(BOOL)isVRMode {
    
    if (isVRMode) {
        [[WVRUserModel sharedInstance] setPlayerMode:PLAYER_MODE_VR];
    } else {
        [[WVRUserModel sharedInstance] setPlayerMode:PLAYER_MODE_MOBILE];
    }
}

- (NSNumber *)defaultbitType {
    
    BOOL isDefault_SD = [WVRUserModel sharedInstance].defaultDefinition == 1;
    NSNumber *defaultbitType = isDefault_SD ? @(MODE_OCTAHEDRON) : @(MODE_SPHERE);
    
    return defaultbitType;
}

/// 在1G内存的设备上分屏模式只能播放非4K视频
- (BOOL)canSwitchVR {
    
    if ([WVRDeviceModel is4KSupport]) {
        return YES;
    }
    
    for (WVRPlayUrlModel *model in self.currentLinkDict.allValues) {
        if (![model.definition isEqualToString:kDefinition_HD]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canChangeDefinition {
    
    NSDictionary *linkDict = [self.parserdUrlModelDict objectForKey:self.curUrlModel.cameraStand];
    
    return linkDict.count > 1;
}

- (BOOL)haveValidUrlModel {
    
    NSDictionary *linkDict = [self.parserdUrlModelDict.allValues firstObject];
    return linkDict.count > 0;
}

- (NSDictionary *)currentLinkDict {
    
    return [self.parserdUrlModelDict objectForKey:self.curUrlModel.cameraStand];
}

- (WVRStreamType)streamType {
    
    return _streamType;
}

- (NSString *)videoTitle {
    
    return _videoTitle ?: @"";
}

- (NSString *)needParserURL {
    
    if (self.isChargeable) {
        
        return [self decodeChargeUrl];
    }
    
    NSString *urlStr = @"";
    
    if ([_needParserURL hasPrefix:@"rtmp://"]) {
        
        NSArray *tmpArr = [_needParserURL componentsSeparatedByString:@"&flag"];
        urlStr = [tmpArr firstObject];
        
        return urlStr;
    }
    
    if ([_needParserURL containsString:@".m3u8"] && [_needParserURL containsString:@"&flag"]) {
        
        NSArray *tmpArr = [_needParserURL componentsSeparatedByString:@"&flag"];
        urlStr = [tmpArr firstObject];
        
        return urlStr;
    }
    
    return _needParserURL;
}

- (NSString *)decodeChargeUrl {
    
    if (_needParserURL.length < 1) { return @""; }
    
    NSString *urlStr = @"";
    
    Security *secu = [Security getInstance];
    urlStr = [secu Security_StandardDecrypt:_needParserURL withAlgid:secu.payAlgid];
    
    if (([urlStr hasPrefix:@"rtmp://"] || [urlStr containsString:@".m3u8"]) && [urlStr containsString:@"&flag"]) {
        
        NSArray *tmpArr = [urlStr componentsSeparatedByString:@"&flag"];
        urlStr = [tmpArr firstObject];
    }
    
    return urlStr;
}

- (BOOL)isNeedParserURL {
    
    if ([self.needParserURL hasPrefix:@"http"] && [self.needParserURL containsString:@"&flag"]) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)canTryNextPlayUrl {
    
    if (self.playUrls.count > (_currentUrlIndex + 1)) {
        
        return YES;
    }
    return NO;
}

// 默认为NO，子类需要可重写
- (BOOL)canPlayNext {
    
    return NO;
}

/// 默认为nil，子类需要可重写
- (NSString *)nextPlayVideoTitle {
    
    return nil;
}

- (NSString *)defaultStandType {
    
    if (self.isFootball) {
        return kFootballDefaultStand;
    }
    
    if (self.parserdUrlModelDict.count == 1) {
        return self.parserdUrlModelDict.allKeys.firstObject;
    }
    
    WVRMediaDto *dto = self.mediaDtos.lastObject;
    return dto.srcName ?: dto.source;
}

- (NSString *)currentStandType {
    
    return self.curUrlModel.cameraStand;
}

#pragma mark - external func

+ (DefinitionType)definitionToType:(NSString *)defi {
    
    if ([defi isEqualToString:kDefinition_ST]) { return DefinitionTypeST; }
    if ([defi isEqualToString:kDefinition_SD]) { return DefinitionTypeSD; }
    if ([defi isEqualToString:kDefinition_HD]) { return DefinitionTypeHD; }
    if ([defi isEqualToString:kDefinition_XD]) { return DefinitionTypeXD; }
    if ([defi isEqualToString:kDefinition_SDA]) { return DefinitionTypeSDA; }
    if ([defi isEqualToString:kDefinition_SDB]) { return DefinitionTypeSDB; }
    if ([defi isEqualToString:kDefinition_TDA]) { return DefinitionTypeTDA; }
    if ([defi isEqualToString:kDefinition_TDB]) { return DefinitionTypeTDB; }
    if ([defi isEqualToString:kDefinition_AUTO]) { return DefinitionTypeAUTO; }
    
    DDLogError(@"definitionToType 转换未知类型, %@", defi);
    return 0;
}

+ (NSString *)typeToDefinition:(DefinitionType)type {
    
    switch (type) {
        case DefinitionTypeST:
            return kDefinition_ST;
        case DefinitionTypeSD:
            return kDefinition_SD;
        case DefinitionTypeHD:
            return kDefinition_HD;
        case DefinitionTypeXD:
            return kDefinition_XD;
        case DefinitionTypeSDA:
            return kDefinition_SDA;
        case DefinitionTypeSDB:
            return kDefinition_SDB;
        case DefinitionTypeTDA:
            return kDefinition_TDA;
        case DefinitionTypeTDB:
            return kDefinition_TDB;
        case DefinitionTypeAUTO:
            return kDefinition_AUTO;
            
        default:
            break;
    }
    DDLogError(@"definitionToType 转换未知类型, %ld", (long)type);
    return kDefinition_ST;
}

+ (NSString *)definitionToTitle:(NSString *)defi {
    
    if ([defi isEqualToString:kDefinition_ST]) { return @"高清"; }
    if ([defi isEqualToString:kDefinition_SD]) { return @"超清"; }
    if ([defi isEqualToString:kDefinition_XD]) { return @"超清"; }
    if ([defi isEqualToString:kDefinition_HD]) { return @"原画"; }
    if ([defi isEqualToString:kDefinition_SDA]) { return @"高清"; }
    if ([defi isEqualToString:kDefinition_SDB]) { return @"超清"; }
    if ([defi isEqualToString:kDefinition_TDA]) { return @"超清"; }
    if ([defi isEqualToString:kDefinition_TDB]) { return @"超清"; }
    
    DDLogError(@"definitionToTitle 转换未知类型, %@", defi);
    return @"超清";
}

+ (WVRRenderType)renderTypeForStreamType:(WVRStreamType)streamType definition:(NSString *)definition renderTypeStr:(NSString *)renderTypeStr {
    
    DefinitionType defiType = [[self class] definitionToType:definition];
    
    WVRRenderType renderType = -1;
    if (streamType == STREAM_2D_TV) {
        renderType = MODE_RECTANGLE;
    } else {
        renderType = [[self class] renderTypeForRenderTypeStr:renderTypeStr];
    }
    
    BOOL isSD = (DefinitionTypeSD == defiType || DefinitionTypeSDA == defiType || DefinitionTypeSDB == defiType);
    if ((renderType < 0 || renderType == MODE_SPHERE) && isSD) {
        renderType = MODE_OCTAHEDRON;
    }
    if (renderType < 0) {
        switch (streamType) {
            case STREAM_3D_WASU:
                renderType = MODE_RECTANGLE_STEREO;
                break;
            case STREAM_2D_TV:
                renderType = MODE_RECTANGLE;
                break;
            case STREAM_VR_LIVE:
                renderType = MODE_SPHERE;
                break;
            default:
                renderType = MODE_SPHERE;
                break;
        }
    }
    return renderType;
}

+ (WVRRenderType)renderTypeForDefinitionStr:(NSString *)definition renderTypeStr:(NSString *)renderTypeStr {
    
    if ([definition isEqualToString:kDefinition_SD]) { return MODE_OCTAHEDRON; }   // 2k八面体
    
    WVRRenderType renType = [[self class] renderTypeForRenderTypeStr:renderTypeStr];
    
    if (renType >= 0) { return renType; }
    
    if ([definition isEqualToString:kDefinition_HD]) { return MODE_SPHERE; }       // 2k球面
    if ([definition isEqualToString:kDefinition_ST]) { return MODE_SPHERE; }       // 4k球面
    
    DDLogError(@"renderTypeForDefinitionStr: 未预判到渲染类型-definition: %@", definition);
    
    return MODE_SPHERE;
}

+ (WVRRenderType)renderTypeForRenderTypeStr:(NSString *)renderTypeStr {
    
    if (renderTypeStr.length == 0) { return MODE_SPHERE; }
    
    if ([renderTypeStr isEqualToString:RENDER_TYPE_SPHERE]) {
        return MODE_SPHERE;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_OCTAHEDRAL]) {
        return MODE_OCTAHEDRON;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_360_2D]) {
        return MODE_SPHERE;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_360_2D_OCTAHEDRAL]) {
        return MODE_OCTAHEDRON;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_PLANE_2D]) {
        return MODE_RECTANGLE;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_PLANE_3D_LR]) {
        return MODE_RECTANGLE_STEREO;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_PLANE_3D_UD]) {
        return MODE_RECTANGLE_STEREO_TD;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_360_3D_LF]) {
        return MODE_SPHERE_STEREO_LR;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_360_3D_UD]) {
        return MODE_SPHERE_STEREO_TD;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_180_PLANE]) {
        return MODE_HALF_SPHERE;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_180_3D_UD]) {
        return MODE_HALF_SPHERE_TD;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_180_3D_LF]) {
        return MODE_HALF_SPHERE_LR;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_360_OCT_3D]) {
        return MODE_OCTAHEDRON_STEREO_LR;
    }
    if ([renderTypeStr isEqualToString:RENDER_TYPE_180_3D_OCT]) {
        return MODE_OCTAHEDRON_HALF_LR;
    }
    
    return -1;
}

#pragma mark - parserPlayUrl

- (void)parserPlayUrl:(complationBlock)complation {
    
    // live 类型此方法已被重写
    if (self.isFootball) {
        
        [self parserFootballPlayUrl:complation];
        
    } else if (self.isNeedParserURL) {
        
        [self parserMoreTVPlayUrl:complation];
        
    } else {
        
        [self parserNotMoreTVPlayUrl:complation];
    }
}

- (void)parserFootballPlayUrl:(complationBlock)complation {
    
    // 使用二维字典存储机位列表，及某个机位对应的清晰度列表
    NSMutableDictionary<NSString *, NSDictionary<NSString *, WVRPlayUrlModel *> *> *dict = [NSMutableDictionary dictionary];
    
    for (WVRMediaDto *dto in self.mediaDtos) {
        
        if (!dto.playUrl) { continue; }
        if (!dto.source) { continue; }
        
        WVRPlayUrlModel *model = [[WVRPlayUrlModel alloc] init];
        model.url = [NSURL URLWithUTF8String:dto.playUrl];
        model.renderType = dto.renderType;
        model.definition = dto.curDefinition;
        model.cameraStand = dto.source;
        
        NSMutableDictionary *linkDict = nil;
        if ([dict objectForKey:dto.srcName]) {
            linkDict = (NSMutableDictionary *)[dict objectForKey:dto.srcName];
        } else {
            linkDict = [NSMutableDictionary dictionary];
        }
        
        linkDict[dto.resolution] = model;
        
        if (linkDict.count == 1) {
            dict[dto.source] = linkDict;
        }
    }
    
    _parserdUrlModelDict = dict;
    
    if (complation) {
        complation();
    }
}

/// 车展直播，暂时未用到，在直播链接解析里面已经实现
- (void)parserLiveCarPlayUrl:(complationBlock)complation {
    
    // 使用二维字典存储机位列表，及某个机位对应的清晰度列表
    NSMutableDictionary<NSString *, NSDictionary<NSString *, WVRPlayUrlModel *> *> *dict = [NSMutableDictionary dictionary];
    
    for (WVRMediaDto *dto in self.mediaDtos) {
        
        if (!dto.playUrl) { continue; }
        if (!dto.source) { continue; }
        if (!dto.srcName) { continue; }
        
        NSMutableDictionary *linkDict = nil;
        if ([dict objectForKey:dto.srcName]) {
            linkDict = (NSMutableDictionary *)[dict objectForKey:dto.srcName];
        } else {
            linkDict = [NSMutableDictionary dictionary];
        }
        
        WVRPlayUrlModel *model = [[WVRPlayUrlModel alloc] init];
        model.url = [NSURL URLWithUTF8String:dto.playUrl];
        model.renderType = dto.renderType;
        model.definition = dto.curDefinition;
        model.cameraStand = dto.srcName;
        
        linkDict[dto.resolution] = model;
        
        if (linkDict.count == 1) {
            dict[dto.srcName] = linkDict;
        }
    }
    
    _parserdUrlModelDict = dict;
    
    if (complation) {
        complation();
    }
}

- (void)parserNotMoreTVPlayUrl:(complationBlock)complation {
    
    NSString *urlStr = self.needParserURL;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!urlStr.length) {
        
    } else {
        
        NSURL *tmpURL = [NSURL URLWithUTF8String:urlStr];
        
        WVRPlayUrlModel *model = [[WVRPlayUrlModel alloc] init];
        model.definition = self.needParserURLDefinition ?: kDefinition_ST;
        model.url = tmpURL;
        model.renderType = self.renderTypeStr;
        _tmpCurDefinition = model.definition;
        
        NSMutableDictionary *linkDict = [NSMutableDictionary dictionaryWithDictionary:@{ model.definition : model }];
        dict[kDefault_Camera_Stand] = linkDict;
    }
    
    _parserdUrlModelDict = dict;
    
    DDLogInfo(@"非蘑菇片源__播放链接：%@", self.needParserURL);
    
    if (complation) {
        complation();
    }
}

- (void)parserMoreTVPlayUrl:(complationBlock)complation {
    
    kWeakSelf(self);
    [WVRParseUrl parserUrl:self.needParserURL callback:^(WVRParserUrlResult *result) {
        
        if (!weakself) { return; }
        
        // 注释：电视猫平面视频（电视剧、电影）、普通VR全景视频取所有清晰度、特殊渲染类型视频取ST和HD、华数电影解析不走这里
        
        BOOL isNotCommon = ![weakself isCommonRenderTypeVideo];
        BOOL isTV = (weakself.streamType == STREAM_2D_TV);
        BOOL isPlane = [weakself isPlaneRenderTypeVideo];
        
        // 使用二维字典存储机位列表，及某个机位对应的清晰度列表
        NSMutableDictionary<NSString *, WVRPlayUrlModel *> *linkDict = [NSMutableDictionary dictionary];
        
        for (WVRParserUrlElement *urlElement in result.urlElementList) {
            
            if (isTV) {
                // 不过滤
            } else if (isNotCommon || isPlane) {
                // 特殊视频类型
                if (urlElement.defiType != DefinitionTypeST && urlElement.defiType != DefinitionTypeHD) {
                    continue;
                }
                
            } else if (result.haveTDA_TDB) {
                // 常规视频包含TDA和TDB链接
                if (urlElement.defiType != DefinitionTypeTDA && urlElement.defiType != DefinitionTypeTDB) {
                    continue;
                }
                
            } else if (result.haveSDA_SDB) {
                // 常规视频包含SDA和SDB链接
                if (urlElement.defiType != DefinitionTypeSDA && urlElement.defiType != DefinitionTypeSDB) {
                    continue;
                }
                
            } else {
                // 常规视频且包含SDA和SDB链接
                if (urlElement.defiType == DefinitionTypeAUTO) {
                    continue;
                }
            }
            WVRPlayUrlModel *model = [[WVRPlayUrlModel alloc] initWithElement:urlElement];
            if (nil == model) { continue; }
            
            model.renderType = self.renderTypeStr;
            
            linkDict[model.definition] = model;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (linkDict.count) {
            dict[kDefault_Camera_Stand] = linkDict;
        }
        _parserdUrlModelDict = dict;
        
        if (complation) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                complation();
            });
        }
    }];
}

- (instancetype)nextVideoEntity {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (instancetype)nextPlayUrlVE {
    
    if (self.playUrls.count > (_currentUrlIndex + 1)) {
        
        self.needParserURL = [self.playUrls objectAtIndex:(++ _currentUrlIndex)];
    }
    
    return self;
}

- (BOOL)canChangeToCameraStand:(NSString *)standType {
    
    NSDictionary *linkDict = [self.parserdUrlModelDict objectForKey:standType];
    
    return (linkDict != nil);
}

- (instancetype)changeCameraStand:(NSString *)standType {
    
    NSString *resolution = self.curUrlModel.definition;
    
    NSDictionary *linkDict = [self.parserdUrlModelDict objectForKey:standType];
    
    if (!linkDict) {
        DDLogError(@"Error: 切换到了未知机位, %@。", standType);
    }
    
    WVRPlayUrlModel *model = [linkDict objectForKey:resolution];
    if (!model) {
        model = [linkDict.allValues firstObject];
    }
    
    self.curUrlModel = model;
    
    return self;
}

- (WVRPlayUrlModel *)playUrlModelForDefinition:(NSString *)defi {
    
    if (defi.length < 1) {
        DDLogError(@"Error: 切换到了空的清晰度");
        return nil;
    }
    
    NSDictionary *linkDict = [self.parserdUrlModelDict objectForKey:self.curUrlModel.cameraStand ?: [self defaultStandType]];
    if (!linkDict) {
        linkDict = [[self.parserdUrlModelDict allValues] firstObject];
    }
    WVRPlayUrlModel *model = [linkDict objectForKey:defi];
    
    return model;
}

#pragma mark - get the url for playing

- (NSURL *)playUrlForStartPlay {
    
    BOOL have_SDA_SDB = [self haveSDA_SDB];
    BOOL haveTDA_TDB = [self haveTDA_TDB];
    
    NSString *defi_SD = kDefinition_SD;
    if (have_SDA_SDB) {
        defi_SD = kDefinition_SDB;
    } else if (haveTDA_TDB) {
        defi_SD = kDefinition_TDB;
    } else {
        defi_SD = [self isCommonRenderTypeVideo] ? kDefinition_SD : kDefinition_HD;
    }
    
    NSString *defi_ST = have_SDA_SDB ? kDefinition_SDA : kDefinition_ST;
    if (haveTDA_TDB) {
        defi_ST = kDefinition_TDA;
    }
    
    self.curUrlModel = [self playUrlModelForDefinition:defi_SD];
    
    if (self.isDefault_SD && nil != self.curUrlModel) {
        
    } else {
        self.curUrlModel = [self playUrlModelForDefinition:defi_ST];
    }
    if (nil == self.curUrlModel) {
        self.curUrlModel = [[self.parserdUrlModelDict objectForKey:[self defaultStandType]].allValues firstObject];
    }
    if (nil == self.curUrlModel) {
        self.curUrlModel = [[self.parserdUrlModelDict.allValues firstObject].allValues firstObject];
    }
    
    DDLogInfo(@"playUrlForStartPlay_camreaStand = %@\nparserdUrlModelDict.count = %d", self.curUrlModel.cameraStand, (int)self.parserdUrlModelDict.count);
    return self.curUrlModel.url;
}

- (NSURL *)playUrlForDefinition:(NSString *)definition {
    
    self.curUrlModel = [self playUrlModelForDefinition:definition];
    
    if (nil == self.curUrlModel) {
        return [self playUrlForStartPlay];
    }
    
    return self.curUrlModel.url;
}

- (NSURL *)playUrlChangeToNextDefinition {
    
    self.curUrlModel = [self playUrlModelForDefinition:[self checkNextDefinition]];
    
    return self.curUrlModel.url;
}

/// 将播放失败的model移除
- (NSURL *)tryNextDefinitionWhenPlayFaild {
    
    DDLogInfo(@"tryNextDefinitionWhenPlayFaild error link: %@", self.curUrlModel.url);
    
    NSMutableDictionary *linkDict = (NSMutableDictionary *)[_parserdUrlModelDict objectForKey:self.curUrlModel.cameraStand];
    
    if (![linkDict isKindOfClass:[NSMutableDictionary class]]) {
        _parserdUrlModelDict = [NSMutableDictionary dictionary];        // 将异常暴露出来
        
        DDLogInfo(@"tryNextDefinitionWhenPlayFaild linkDict is Not NSMutableDictionary");
        
        return self.curUrlModel.url;
    }
    
    [linkDict removeObjectForKey:self.curUrlModel.definition];
    if (linkDict.count == 0) {
        NSMutableDictionary *muDict = (NSMutableDictionary *)self.parserdUrlModelDict;
        [muDict removeObjectForKey:self.curUrlModel.cameraStand];
    }
    
    self.curUrlModel = [self playUrlModelForDefinition:[self checkNextDefinition]];
    
    DDLogInfo(@"tryNextDefinitionWhenPlayFaild next link: %@", self.curUrlModel.url);
    
    return self.curUrlModel.url;
}

#pragma mark - have SDA or SDB - TDA or TDB

- (BOOL)haveSDA_SDB {
    for (WVRPlayUrlModel *model in [self.parserdUrlModelDict.allValues firstObject].allValues) {
        if (model.defiType == DefinitionTypeSDA || model.defiType == DefinitionTypeSDB) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)haveTDA_TDB {
    for (WVRPlayUrlModel *model in [self.parserdUrlModelDict.allValues firstObject].allValues) {
        if (model.defiType == DefinitionTypeTDA || model.defiType == DefinitionTypeTDB) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 是否为特殊类型视频

- (BOOL)isCommonRenderTypeVideo {
    
    return [[self class] isCommonVideoForRenderType:self.renderTypeStr];
}

- (BOOL)isPlaneRenderTypeVideo {
    
    return [self.renderTypeStr containsString:@"PLANE"];
}

+ (BOOL)isCommonVideoForRenderType:(NSString *)renderType {
    
    if ([renderType isEqualToString:RENDER_TYPE_360_3D_LF]) {
        return NO;
    }
    if ([renderType isEqualToString:RENDER_TYPE_360_3D_UD]) {
        return NO;
    }
    if ([renderType isEqualToString:RENDER_TYPE_180_PLANE]) {
        return NO;
    }
    if ([renderType isEqualToString:RENDER_TYPE_180_3D_UD]) {
        return NO;
    }
    if ([renderType isEqualToString:RENDER_TYPE_180_3D_LF]) {
        return NO;
    }
    return YES;
}

#pragma mark - private func

/**
 从playURLModel列表中获取下一个可播放的清晰度(private function)
 
 @return NextDefinition
 */
- (NSString *)checkNextDefinition {
    
    NSArray *defiArray = nil;
    
    if ([self haveTDA_TDB]) {
        defiArray = @[ kDefinition_TDA, kDefinition_TDB ];
    } else if ([self haveSDA_SDB]) {
        defiArray = @[ kDefinition_SDA, kDefinition_SDB ];
    } else if ([self isCommonRenderTypeVideo]) {
        defiArray = @[ kDefinition_ST, kDefinition_SD, kDefinition_HD ];
    } else {
        defiArray = @[ kDefinition_ST, kDefinition_HD ];
    }
    int count = (int)defiArray.count;
    
    int idx = 0;
    for (NSString *str in defiArray) {      // get next definition key
        idx = (idx + 1) % count;
        if ([self.curDefinition isEqualToString:str]) { break; }        // protect for endless loop
    }
    
    NSString *defi = defiArray[idx];          // get next non-null value
    
    int protect = 0;        // protect for endless loop (parserdUrlDictionary has only one object)
    while (nil == [self playUrlModelForDefinition:defi]) {
        idx = (idx + 1) % count;
        defi = defiArray[idx];
        if ((++ protect) > count) {
            return self.curDefinition;
        }
    }
    
    DebugLog(@"final curDefinition:%@", defi);
    return defi;
}

@end


@implementation WVRVideoBIEntity

- (NSString *)videoTag {
    
    return _videoTag ?: @"";
}

@end
