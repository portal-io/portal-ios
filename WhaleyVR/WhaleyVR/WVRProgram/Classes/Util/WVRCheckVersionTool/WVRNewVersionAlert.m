//
//  WVRNewVersionAlert.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNewVersionAlert.h"
#import "WVRCheckVersionTool.h"

@interface WVRNewVersionAlert ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadowV;

@property (weak, nonatomic) IBOutlet UILabel *versionL;

//@property (weak, nonatomic) IBOutlet UILabel *versionDescL;
- (IBAction)cancleBtnOnClick:(id)sender;

- (IBAction)updateBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textV;


@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (nonatomic) WVRNewVersionAlertInfo* vInfo;
@end
@implementation WVRNewVersionAlert

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //        NSLog(@"%ld",(long)constraint.firstAttribute);
        //据底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    NSArray* subviews = self.subviews;
    for (UIView * view in subviews) {
        NSArray * cons = view.constraints;
        for (NSLayoutConstraint* constraint in cons) {
            //            NSLog(@"%ld",(long)constraint.firstAttribute);
            //据底部0
            constraint.constant = fitToWidth(constraint.constant);
        }
    }
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    [self.shadowV addGestureRecognizer:tapG];
    self.textV.font = kFontFitForSize(12.f);
    self.textV.delegate = self;
    self.versionL.font = kFontFitForSize(9.f);
    self.titleL.font = kFontFitForSize(23.f);
//    self.textV.textContainer.lineFragmentPadding = 0;
//    self.textV.textContainerInset = UIEdgeInsetsZero;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.textV.editable = NO;
//    self.textV.selectable = NO;
}

-(void)fillData:(WVRNewVersionAlertInfo*)info{

    self.versionL.text = [NSString stringWithFormat:@"版本：%@  大小：%@", info.version, info.size];
    self.textV.text = info.versionDesc;
   
//    [self.textV setContentOffset:CGPointZero animated:NO];
    [self.textV scrollsToTop];
}

- (void)disMissView {
    
    [self removeFromSuperview];
    [WVRCheckVersionTool cancelUpdate];
}

- (IBAction)cancleBtnOnClick:(id)sender {
    
    [self removeFromSuperview];
    [WVRCheckVersionTool cancelUpdate];
}

- (IBAction)updateBtnOnClick:(id)sender {
    
    [self removeFromSuperview];
    [WVRCheckVersionTool gotoAppstoreForNewVersion];
}

@end


@implementation WVRNewVersionAlertInfo

@end
