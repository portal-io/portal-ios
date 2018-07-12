//
//  WVRGiftView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/11/23.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPageView.h"
#import "WVRViewModel.h"
#import "WVRViewProtocol.h"

#define HEIGHT_PORTRAIT_PAGE (135.f)
#define HEIGHT_HOR_PAGE (254.f)
#define COUNT_PRO_ITEM_PAGE (8)
#define COUNT_HOR_ITEM_PAGE (7)


@interface WVRGiftViewModel : WVRViewModel

@property (nonatomic, assign) BOOL enableSendGift;

@property (nonatomic, assign) BOOL enableSendMember;

@property (nonatomic, assign) BOOL enableProgramMembers;

@property (nonatomic, strong) NSString * memberName;

@property (nonatomic, strong) RACCommand * gSendGiftCmd;

@property (nonatomic, strong) RACCommand * gSendMemberCmd;

@property (nonatomic, strong) RACCommand * gGoRechargeCmd;

@property (nonatomic, assign) CGFloat pageViewHeight;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger curPageIndex;

@property (nonatomic, assign) NSInteger toPageIndex;

@property (nonatomic, assign) NSInteger wCurrencyBalance;

@end

@interface WVRGiftTempView : UIView<WVRViewProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *gProgramMembersView;

@property (weak, nonatomic) IBOutlet WVRPageView *gGiftPageView;

@property (weak, nonatomic) UIView * gDanmuView;

@end
