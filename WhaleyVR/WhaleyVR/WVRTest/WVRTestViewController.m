//
//  WVRTestViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/12/6.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTestViewController.h"
#import "WVRRNGoldViewController.h"
#import "WVRRNDemoViewController.h"
//#import "WVRRNLiveCompleteVC.h"

@interface WVRTestViewController ()
- (IBAction)gotoRNGoldOnClick:(id)sender;

@end

@implementation WVRTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)gotoRNGoldOnClick:(id)sender {
//    WVRRNLiveCompleteVC * vc = [[WVRRNLiveCompleteVC alloc] init];
//    vc.createArgs = @{@"imgUrl":@"http://image.aginomoto.com/image/get-image/10000004/14906865712634948188.jpg/zoom/1080/608"};
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
