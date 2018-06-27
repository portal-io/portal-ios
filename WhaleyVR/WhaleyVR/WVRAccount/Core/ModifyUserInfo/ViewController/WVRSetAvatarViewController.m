//
//  WVRSetAvatarViewController.m
//  WhaleyVR
//
//  Created by zhangliangliang on 9/12/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import "WVRSetAvatarViewController.h"
#import "WVRSetAvatarView.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "WVRUserModel.h"
#import "WVRSetAvatarViewModel.h"

@interface WVRSetAvatarViewController ()

@property (nonatomic, strong) WVRSetAvatarView *contentView;
@property (strong, nonatomic) NSData *fileData;

@property (nonatomic, strong) WVRSetAvatarViewModel * gSetAvatarViewModel;

@end


@implementation WVRSetAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSelf];
    [self configSubviews];
    [self installRAC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_contentView updateAvatar:[WVRUserModel sharedInstance].tmpAvatar];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

-(WVRSetAvatarViewModel *)gSetAvatarViewModel
{
    if (!_gSetAvatarViewModel) {
        _gSetAvatarViewModel = [[WVRSetAvatarViewModel alloc] init];
    }
    return _gSetAvatarViewModel;
}

-(void)installRAC
{
    
    [[self.gSetAvatarViewModel mCompleteSignal] subscribeNext:^(id  _Nullable x) {
       [self httpSetAvatarSuccessBlock: x];
    }];
    [[self.gSetAvatarViewModel mFailSignal] subscribeNext:^(WVRErrorViewModel*  _Nullable x) {
        [self requestFaild:x.errorMsg];
    }];
}

- (void)configSelf {
    
    [self setTitle:@"个人相册"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickPickImage:)];
}

- (void)configSubviews {
    
    _contentView = [[WVRSetAvatarView alloc] init];
    [self.view addSubview:_contentView];
    
    _contentView.frame = self.view.bounds;
    
    [_contentView updateAvatar:_image];
}

/**
 @ 调用ActionSheet
 */
- (void)callActionSheetFunc {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    kWeakSelf(self);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself dealWithSelectedImageFromCamera];
        }];
        [alertController addAction:cameraAction];
    }
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself dealWithSelectedImageFromPhotos];
    }];
    [alertController addAction:photosAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealWithSelectedImageFromCamera {
    
    [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_takePics];
    
    [self dealWithSelectedImage:UIImagePickerControllerSourceTypeCamera];
}

- (void)dealWithSelectedImageFromPhotos {
    
    [WVRTrackEventMapping curEvent:kEvent_information flag:kEvent_information_burialPoint_gallery];
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self dealWithSelectedImage:sourceType];
}

- (void)dealWithSelectedImage:(NSUInteger)sourceType {
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        
        UIImage *compressToSizeImg = [img compresstoSize:self.view.bounds.size];
        
        [self performSelector:@selector(saveImage:) withObject:compressToSizeImg afterDelay:0];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickPickImage:(id)sender {
    
    [self callActionSheetFunc];
}

- (void)saveImage:(UIImage *)image {
    
    [WVRUserModel sharedInstance].tmpAvatar = image;
    
    NSString *imageFilePath = [WVRFilePathTool getDocumentWithName:@"selfPhoto.jpg"];
    
    NSLog(@"imageFile ->> %@", imageFilePath);
    
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    
    [data writeToFile:imageFilePath atomically:YES];    // 写入文件
    
    [self showProgress];
    [self httpSetAvatar:data keyName:@"Filedata" fileName:[imageFilePath lastPathComponent]];
    
    DDLogInfo(@"setavatarImage:%@", image);
    [_contentView updateAvatar:image];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAvatar:)]) {
        [self.delegate updateAvatar:image];
    }
}

- (void)requestFaild:(NSString *)errorStr {
    
    [self hideProgress];
    [self showMessageToWindow:errorStr];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    
    if (nil == image) { return nil; }
    
    UIImage *newimage;
    
    CGSize oldsize = image.size;
    CGRect rect;
    if (asize.width/asize.height > oldsize.width/oldsize.height) {
        rect.size.width = asize.height*oldsize.width/oldsize.height;
        rect.size.height = asize.height;
        rect.origin.x = (asize.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    else{
        rect.size.width = asize.width;
        rect.size.height = asize.width*oldsize.height/oldsize.width;
        rect.origin.x = 0;
        rect.origin.y = (asize.height - rect.size.height)/2;
    }
    UIGraphicsBeginImageContext(asize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, asize.width, asize.height));    //clear background
    [image drawInRect:rect];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma set avatar

- (void)httpSetAvatar:(NSData *)fileData keyName:(NSString *)keyName fileName:(NSString *)fileName {
    self.gSetAvatarViewModel.fileData = fileData;
    self.gSetAvatarViewModel.keyName = keyName;
    self.gSetAvatarViewModel.fileName = fileName;
    [[self.gSetAvatarViewModel setAvatarCmd] execute:nil];
//    WVRHttpSetAvatar * cmd = [[WVRHttpSetAvatar alloc] init];
//    NSMutableDictionary * httpDic = [[NSMutableDictionary alloc] init];
//    httpDic[kHttpParams_setAvatar_accesstoken] = [WVRUserModel sharedInstance].sessionId;
//    cmd.fileData = fileData;
//    cmd.keyName = keyName;
//    cmd.fileName = fileName;
//    cmd.bodyParams = httpDic;
//    cmd.successedBlock = ^(NSString * successMsg) {
//        [self httpSetAvatarSuccessBlock:successMsg];
//    };
//    cmd.failedBlock = ^(NSString* errMsg) {
//        NSLog(@"fail msg: %@", errMsg);
//        [self requestFaild:errMsg];
//    };
//    [cmd execute];
}

- (void)httpSetAvatarSuccessBlock:(NSString *)successMsg {
    
    [self hideProgress];
    [self.navigationController popViewControllerAnimated:YES];
    if ([successMsg isKindOfClass:[NSString class]]) {
        [self showMessageToWindow:successMsg];    
    }
    
}

@end
