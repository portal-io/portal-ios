//
//  WVRCollectionViewController.m
//  WhaleyVR
//
//  Created by qbshen on 2017/7/19.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRCollectionViewController.h"

@interface WVRCollectionViewController ()

@end

@implementation WVRCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gCollectionView];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.gCollectionView.bounds = self.view.bounds;
//    self.gCollectionView.center = self.view.center;
    
}

-(UICollectionView *)gCollectionView
{
    if (!_gCollectionView) {
        _gCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    return _gCollectionView;
}

@end
