//
//  WVRGiftAnimalViewCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/28.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftAnimalViewCell.h"
#import "WVRGiftAnimalViewCellViewModel.h"
#import "WVRGiftShakeLable.h"


@interface WVRGiftAnimalViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIconIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *giftNameL;
@property (weak, nonatomic) IBOutlet UIImageView *giftIconIV;

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet WVRGiftShakeLable *giftCountL;

@property (nonatomic, weak) WVRGiftAnimalViewCellViewModel *gViewModel;

@property (nonatomic, assign) CGAffineTransform gGiftCountLOriginTransform;

@property (nonatomic, assign) NSInteger delayCount;
@end


@implementation WVRGiftAnimalViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delayCount = 4;
    self.gGiftCountLOriginTransform = self.giftCountL.transform;
    self.userIconIV.layer.masksToBounds = YES;
    self.userIconIV.layer.cornerRadius = self.userIconIV.height/2;
    self.giftIconIV.layer.masksToBounds = YES;
    self.giftIconIV.layer.cornerRadius = self.giftIconIV.height/2;
    self.backgroundV.layer.masksToBounds = YES;
    self.backgroundV.layer.cornerRadius = self.backgroundV.height/2;
    UIFont *font = [UIFont fontWithName:@"NanumPen" size:31.f];
    if (font) {
        self.giftCountL.font = font;
    }
//    self.giftCountL.borderColor = [UIColor redColor];
}

-(void)bindViewModel:(id)viewModel
{
    if (self.gViewModel==viewModel) {
        return;
    }
    
//    WVRGiftAnimalViewCellViewModel * curViewModel = viewModel;
    self.gViewModel = viewModel;
    [self.userIconIV wvr_setImageWithURL:[NSURL URLWithString:self.gViewModel.userIcon] placeholderImage:HOLDER_HEAD_IMAGE];
    [self.giftIconIV wvr_setImageWithURL:[NSURL URLWithString:self.gViewModel.giftIcon] placeholderImage:HOLDER_HEAD_IMAGE];
    self.userNameL.text = self.gViewModel.userName;
    if (self.gViewModel.toUserName.length > 0) {
        self.giftNameL.text = [NSString stringWithFormat:@"为@%@ 送出%@",self.gViewModel.toUserName,self.gViewModel.giftName];
    }else{
        self.giftNameL.text = [NSString stringWithFormat:@"送出%@", self.gViewModel.giftName];
    }
    self.gViewModel.curGiftCount = 1;
    [self layoutViewWidth];
//    [self.giftCountL startAnimWithDuration:0.3];
    [self installRAC];
}

-(void)installRAC
{
    @weakify(self);
    self.gViewModel.gStartAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self startAnimation];
        return [RACSignal empty];
    }];
    self.gViewModel.gGiftCountAnimationCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self animationCount];
        return [RACSignal empty];
    }];
}

-(void)startAnimation
{
    NSLog(@"gift cell startAnimation");
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)layoutViewWidth
{
    CGSize userNameSize = [WVRComputeTool sizeOfString:self.userNameL.text Size:CGSizeMake(800, self.userNameL.height) Font:self.userNameL.font];
    CGSize giftNameSize = [WVRComputeTool sizeOfString:self.giftNameL.text Size:CGSizeMake(800, self.giftNameL.height) Font:self.giftNameL.font];
    CGFloat curWidth = MAX(userNameSize.width, giftNameSize.width);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MIN((180.f+curWidth),(SCREEN_WIDTH-self.x*2)));
        }];
        [self.superview layoutIfNeeded];
        [self.superview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MIN((180.f+curWidth),SCREEN_WIDTH));
        }];
        [self.superview.superview layoutIfNeeded];
    });
}

-(void)responseHiden
{
    NSLog(@"gift cell responseHiden");
    self.alpha = 1.0f;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        NSLog(@"gift cell completiHiden");
        self.gViewModel.animalFinishedBlock(YES);
    }];
    self.gViewModel.finishedBlock(YES, self.gViewModel.giftCount);
}

-(void)finishCount
{
    NSLog(@"gift cell %@ finishCount curCount:%d, count:%d",[self.gViewModel.giftName stringByAppendingString:self.gViewModel.toUserName],self.gViewModel.curGiftCount,self.gViewModel.giftCount);
//    @weakify(self);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        @strongify(self);
        if (self.gViewModel.curGiftCount == self.gViewModel.giftCount) {
            //        [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self responseHiden];
        }else{
            self.gViewModel.curGiftCount ++;
        }
        self.gViewModel.shakeFinishedBlock(YES, self.gViewModel.giftCount);
//    });
}

-(void)animationCount
{
    NSLog(@"gift cell animationCount");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(finishCount) withObject:nil afterDelay:1.5];
    if (self.gViewModel.curGiftCount>1) {
        self.giftCountL.text = [NSString stringWithFormat:@"X%d",self.gViewModel.curGiftCount];
    }else{
        self.giftCountL.text = @"";
    }
    
//    self.giftCountL.width = 0.f;
//    self.giftCountL.height = 0.f;
//    self.giftCountL.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
//    self.hidden = NO;
//    self.alpha = 0;
//    self.giftCountL.transform = self.gGiftCountLOriginTransform;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 1;
//        self.giftCountL.width = 45.f;
//        self.giftCountL.height = 30.f;
//        self.giftCountL.font = [UIFont systemFontOfSize:25.f];
//        CGAffineTransform newTransform =  CGAffineTransformScale(self.gGiftCountLOriginTransform, 2, 2);//2,2表示放大的大小
        
//        self.giftCountL.transform = newTransform;
//        self.giftCountL.transform  = CGAffineTransformMake(1, 0, 0, 1, 0, 0);;
//    } completion:^(BOOL finished) {
    
//        [self performSelector:@selector(animationCount) withObject:nil afterDelay:2];
//    }];
}

@end

