//
//  WVRMyReservationController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyReservationController.h"
#import "WVRMyReservationPresenter.h"

@interface WVRMyReservationController ()

@property (nonatomic) WVRMyReservationPresenter * myReserveP;

@end


@implementation WVRMyReservationController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_Color11;
    self.myReserveP = [[WVRMyReservationPresenter alloc] initWithParams:nil attchView:self];
    UIView* subV = [self.myReserveP getView];
    [self.view addSubview:subV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.myReserveP fetchData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView* subV = [self.myReserveP getView];
    subV.frame = CGRectMake(0, kNavBarHeight, self.view.width, SCREEN_HEIGHT-kNavBarHeight);
}

- (void)initTitleBar {
    [super initTitleBar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestInfo
{
    [super requestInfo];
    [self.myReserveP fetchData];
}
@end
