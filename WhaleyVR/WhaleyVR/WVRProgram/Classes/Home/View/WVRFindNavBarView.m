//
//  WVRFindNavBarView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRFindNavBarView.h"
#import "WVRFindSearchBar.h"

@interface WVRFindNavBarView ()


@property (weak, nonatomic) IBOutlet WVRFindSearchBar *searchBarV;
- (IBAction)startSearchBtnOnClick:(id)sender;
- (IBAction)cachBtnOnClick:(id)sender;
- (IBAction)historyBtnOnClick:(id)sender;

@end


@implementation WVRFindNavBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSearchBarV];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)initSearchBarV
{
    self.searchBarV.layer.masksToBounds = YES;
    self.searchBarV.layer.cornerRadius = self.searchBarV.height/2;
    self.searchBarV.backgroundColor = k_Color10;
}
- (IBAction)startSearchBtnOnClick:(id)sender {
    if (self.startSearchClickBlock) {
        self.startSearchClickBlock();
    }
}

- (IBAction)cachBtnOnClick:(id)sender {
    if (self.cacheClickBlock) {
        self.cacheClickBlock();
    }
}

- (IBAction)historyBtnOnClick:(id)sender {
    if (self.historyClickBlock) {
        self.historyClickBlock();
    }
}

@end
