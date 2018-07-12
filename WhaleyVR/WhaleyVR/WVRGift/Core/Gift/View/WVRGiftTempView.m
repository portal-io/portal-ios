//
//  WVRGiftView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRGiftTempView.h"
#import "YYTextLayout.h"

#define HEIGHT_MEMBER_VIEW (73.f)
#define HEIGHT_BOTTOM_SEND_VIEW (81.f)

@interface WVRGiftTempView()
@property (weak, nonatomic) IBOutlet UIView *membersBackV;
@property (weak, nonatomic) IBOutlet UILabel *membersTitleL;

@property (weak, nonatomic) IBOutlet UILabel *wCurrencyBalanceL;
@property (weak, nonatomic) IBOutlet UIButton *sendGiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *gotoRechargeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageVHeightCons;
@property (weak, nonatomic) IBOutlet UIPageControl *gPageControl;
- (IBAction)sendGiftBtnOnClick:(id)sender;
- (IBAction)goRechargeOnClick:(id)sender;

@property (nonatomic, weak) WVRGiftViewModel * gViewModel;

@property (nonatomic, assign) BOOL enableSGift;
@property (nonatomic, assign) BOOL enableSMember;

@end

@implementation WVRGiftTempView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.gProgramMembersView.backgroundColor = [UIColor clearColor];
    self.sendGiftBtn.layer.masksToBounds = YES;
    self.sendGiftBtn.layer.cornerRadius = fitToWidth(5);
    self.gotoRechargeBtn.layer.masksToBounds = YES;
    self.gotoRechargeBtn.layer.cornerRadius = self.gotoRechargeBtn.height/2;
    self.gotoRechargeBtn.layer.borderWidth = 1.0f;
    self.gotoRechargeBtn.layer.borderColor = k_Color1.CGColor;
    [self.gPageControl addTarget:self action:@selector(pageControlChangevalue) forControlEvents:UIControlEventValueChanged];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gProgramMembersView.height = HEIGHT_MEMBER_VIEW;
}

-(void)bindViewModel:(id)viewModel
{
    if (self.gViewModel == viewModel) {
        return;
    }
    self.gViewModel = viewModel;
    [self installRAC];
}

-(void)installRAC
{
    @weakify(self);
    [RACObserve(self.gViewModel, enableSendGift) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x integerValue]==1) {
            [self enableSendGift];
        }else{
            [self unenableSendGift];
        }
    }];
    [RACObserve(self.gViewModel, enableSendMember) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x integerValue]==1) {
            [self enableSendMember];
        }else{
            [self unenableSendMember];
        }
    }];
    [RACObserve(self.gViewModel, pageViewHeight) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.pageVHeightCons.constant = self.gViewModel.pageViewHeight;
        [self updateEnableProgramMembers];
    }];
    [RACObserve(self.gViewModel, pageCount) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.gViewModel.pageCount==1) {
            self.gPageControl.hidden = YES;
        }else{
            self.gPageControl.hidden = NO;
        }
        self.gPageControl.numberOfPages = self.gViewModel.pageCount;
    }];
    [RACObserve(self.gViewModel, curPageIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.gPageControl.currentPage = self.gViewModel.curPageIndex;
    }];
    [RACObserve(self.gViewModel, enableProgramMembers) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateEnableProgramMembers];
    }];
    [RACObserve(self, gDanmuView) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self addSubview:self.gDanmuView];
    }];
    [RACObserve(self.gViewModel, wCurrencyBalance) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.wCurrencyBalanceL.text = [NSString stringWithFormat:@"%d鲸币",(int)self.gViewModel.wCurrencyBalance];
    }];
    
}

-(void)updateEnableProgramMembers
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat curHeight = 0;
        if (self.gViewModel.enableProgramMembers) {
            self.gProgramMembersView.hidden = NO;
            self.membersBackV.hidden = NO;
            self.membersTitleL.hidden = NO;
            curHeight = self.gViewModel.pageViewHeight+HEIGHT_MEMBER_VIEW+HEIGHT_BOTTOM_SEND_VIEW;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(curHeight);
            }];
        } else {
            self.gProgramMembersView.hidden = YES;
            self.membersBackV.hidden = YES;
            self.membersTitleL.hidden = YES;
            curHeight = self.gViewModel.pageViewHeight+HEIGHT_BOTTOM_SEND_VIEW;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(curHeight);
            }];
        }
        [self.superview layoutIfNeeded];
    });
}

-(void)pageControlChangevalue
{
    self.gViewModel.toPageIndex = self.gPageControl.currentPage;
}

-(void)enableSendGift
{
    self.sendGiftBtn.backgroundColor = k_Color1;
//    self.sendGiftBtn.userInteractionEnabled = YES;
    self.enableSGift = YES;
}

-(void)unenableSendGift
{
    self.sendGiftBtn.backgroundColor = k_Color8;
//    self.sendGiftBtn.userInteractionEnabled = NO;
    self.enableSGift = NO;
}

- (void)enableSendMember {
    
    NSString * title = [NSString stringWithFormat:@"打赏给%@", self.gViewModel.memberName];
    self.sendGiftBtn.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.sendGiftBtn setTitle:title forState:UIControlStateNormal];
    
    if (self.gViewModel.enableSendGift) {
        [self enableSendGift];
    } else {
        [self unenableSendGift];
    }
    self.enableSMember = YES;
}

-(void)unenableSendMember
{
    NSString * title = [NSString stringWithFormat:@"送出"];
    [self.sendGiftBtn setTitle:title forState:UIControlStateNormal];
    if (self.gViewModel.enableSendGift) {
        [self enableSendGift];
    } else {
        [self unenableSendGift];
    }
    self.enableSMember = NO;
}
- (IBAction)sendGiftBtnOnClick:(id)sender {
    if (self.enableSMember) {
        [self.gViewModel.gSendMemberCmd execute:nil];
    } else if (self.enableSGift) {
        [self.gViewModel.gSendGiftCmd execute:nil];
    } else {
        SQToastBottomIn(@"还未选择礼物", self);
    }
}

- (IBAction)goRechargeOnClick:(id)sender {
    
    [WVRAppModel sharedInstance].shouldContinuePlay = YES;
    
    [self.gViewModel.gGoRechargeCmd execute:nil];
}

@end


@implementation WVRGiftViewModel
@synthesize wCurrencyBalance = _wCurrencyBalance;

-(instancetype)init{
    self = [super init];
    if (self) {
        self.wCurrencyBalance = 100;
    }
    return self;
}
-(NSInteger)wCurrencyBalance
{
    return _wCurrencyBalance;
}

-(void)setWCurrencyBalance:(NSInteger)wCurrencyBalance
{
    _wCurrencyBalance = wCurrencyBalance;
}
@end

