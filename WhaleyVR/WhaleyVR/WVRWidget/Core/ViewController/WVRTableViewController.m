//
//  WVRTableViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTableViewController.h"

@interface WVRTableViewController ()

@end


@implementation WVRTableViewController
@synthesize gTableView = _gTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#define kNavBarHeight 64.f

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    self.gTableView.frame = CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-kNavBarHeight);
}


- (UITableView *)gTableView {
    if (!_gTableView) {
        _gTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _gTableView;
}

@end
