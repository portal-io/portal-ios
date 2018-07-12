//
//  WVRPlayerTopToolView.h
//  WhaleyVR
//
//  Created by qbshen on 2017/2/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayViewCell.h"
#import "WVRPlayerTopViewProtocol.h"
#import "WVRPlayTopCellViewModel.h"

@interface WVRPlayerTopView : WVRPlayViewCell<WVRPlayerTopViewProtocol>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnLeadingCons;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

- (IBAction)backOnClick:(id)sender;

- (void)updateLeadingCons;

@end
