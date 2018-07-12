//
//  SQLogManagerController.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQLogManagerController.h"
#import "SQLogMessageTool.h"
#import "AFNetworking.h"

@interface SQLogManagerController ()

@property (weak, nonatomic) UILabel *remindLabel;

//@property (nonatomic, weak) UIButton *previewBtn;
//@property (nonatomic, weak) UIButton *uploadBtn;

@property (nonatomic, weak) UITextView *logView;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, weak) UITextField *urlField;

#pragma mark - lazy var

@property (nonatomic, copy) NSString *logPath;
@property (nonatomic, copy) NSString *logName;
@property (nonatomic, strong) NSArray *logList;

@end


@implementation SQLogManagerController

+ (instancetype)createViewController:(id)createArgs
{
    SQLogManagerController *vc = [[SQLogManagerController alloc] init];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"日志";
    
    [self cleanLogs];
    
    [self configSubviews];
}

- (void)configSubviews {
    
    [self remindLabel];
    [self previewBtn];
    [self logView];
    [self bottomBtn];
    [self urlField];
    [self uploadBtn];
}

#pragma mark - getter

- (NSString *)logPath {
    if (!_logPath) {
        
        _logPath = [WVRFilePathTool getCachesWithName:@"Logs/"];
    }
    
    return _logPath;
}

- (NSArray *)logList {
    
    if (!_logList) {
        
        NSString *path = self.logPath;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        _logList = [fileManager contentsOfDirectoryAtPath:path error:nil];
    }
    
    return _logList;
}

- (NSString *)logName {
    
    if (!_logName) {
        
        NSArray *arr = self.logList;
        _logName = [arr lastObject];
        
        if (!_logName) {
            SQToastInKeyWindow(@"没有日志文件");
        }
    }
    return _logName;
}

- (UILabel *)remindLabel {
    
    if (!_remindLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, self.view.width - 30, 50)];
        label.textColor = [UIColor blackColor];
        label.font = FONT(13);
        label.text = @"默认URL：http://172.29.90.17:8181/upload\n上传完毕后本地日志将清空";
        
        [self.view addSubview:label];
        _remindLabel = label;
    }
    return _remindLabel;
}

- (void)previewBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看日志" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundImageWithColor:k_Color1 forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 130, self.view.width/2 - 40, 40);
    [btn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)uploadBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"上传日志" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundImageWithColor:k_Color1 forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.width/2 + 20, 130, self.view.width/2 - 40, 40);
    [btn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (UITextField *)urlField {
        
    if (!_urlField) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, self.view.width - 40, 40)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.textColor = [UIColor blackColor];
        tf.font = FONT(14);
        tf.placeholder = @"请输入log服务器地址，不输入则保持默认";
        [self.view addSubview:tf];
        _urlField = tf;
    }
    return _urlField;
}

- (UITextView *)logView {
        
    if (!_logView) {
        float y = self.urlField.bottomY + 25;
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(5, y, self.view.width - 10, self.view.height - y - 10)];
        textV.backgroundColor = [UIColor whiteColor];
        textV.textColor = [UIColor blackColor];
        textV.editable = NO;
        textV.font = [WVRAppModel fontFitForSize:11];
        
        [self.view addSubview:textV];
        _logView = textV;
    }
    return _logView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, _logView.bottomY, self.view.width, 10);
        
        [btn addTarget:self action:@selector(bottonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        _bottomBtn = btn;
    }
    return _bottomBtn;
}

#pragma mark - btn Click

- (void)previewBtnClick:(UIButton *)sender {
    
    NSString *path = self.logPath;
    NSString *fileName = self.logName;
    
    if (fileName) {
        
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        self.logView.text = str;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            CGPoint offset = CGPointMake(0, self.logView.contentSize.height - self.logView.frame.size.height);
//            [self.logView setContentOffset:offset animated:YES];
            
            // 使用scrollRangeToVisible滚动到 “从倒数第二个开始获取倒数第一个” 位置
            [self.logView scrollRangeToVisible:NSMakeRange(self.logView.text.length - 1, 1)];
            
//            // 滚动到顶部
//            [self.logView scrollRangeToVisible:NSMakeRange(0, 1)];
        });
    }
}

- (void)uploadBtnClick:(UIButton *)sender {
    
    self.remindLabel.text = @"上传中...";
    
    [self uploadLogFilesToUrl:_urlField.text completeBlock:nil];
}

- (void)bottonBtnClick:(UIButton *)sender {
    
    [self.logView scrollRangeToVisible:NSMakeRange(_logView.text.length - 1, 1)];
}

#pragma mark - action

- (void)uploadLogFilesToUrl:(NSString *)url completeBlock:(void (^)(void))completeBlock {
    
    kWeakSelf(self);
    
    NSString *urlStr = url.length > 0 ? url : @"http://172.29.90.17:8181/upload";
    
    NSString *path = self.logPath;
    NSString *fileName = self.logName;
    
    if (fileName) {
        
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *tmpDic = [WVRAppModel sharedInstance].commenParams;
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
        muDict[@"deviceId"] = [WVRUserModel sharedInstance].deviceId;
        muDict[@"fileList"] = self.logList;
        muDict[@"buildVer"] = kBuildVersion;
        muDict[@"deviceModel"] = [WVRDeviceModel deviceModel];
        
        NSString *logName = [NSString stringWithFormat:@"%@_%@_%@", muDict[@"deviceModel"], muDict[@"deviceId"], [NSDate chinaDate]];
        
        self.logView.text = [muDict toJsonStringPretty];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:urlStr parameters:muDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filePath] name:logName fileName:fileName mimeType:@"text/plain"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                float progerss = uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount;
                weakself.remindLabel.text = [NSString stringWithFormat:@"上传中... %.2f", progerss];
            });
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.remindLabel.text = [responseObject toJsonString];
            });
            
            if (completeBlock) {
                completeBlock();
            }
            @try {
                
                NSString *tmp = @"";
                [tmp writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"log upload success, %@", filePath);
                
            } @catch (NSException *exception) {
                
                NSLog(@"%@", exception);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.remindLabel.text = [NSString stringWithFormat:@"%@", error];
            });
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - private func

- (void)cleanLogs {
    
    NSString *path = self.logPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    if (arr.count <= 1) { return; }     // 文件不能删完，要不就不能继续记录了
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSString *name in arr) {
            NSString *finalPath = [path stringByAppendingPathComponent:name];
            NSData *data = [NSData dataWithContentsOfFile:finalPath options:NSUncachedRead error:nil];
            if (data.length < 500) {
                [WVRFilePathTool removeFileAtPath:finalPath];
            }
        }
    });
}

@end
