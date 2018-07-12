//
//  WVRMineViewModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRViewModel.h"
#import "WVRTableViewAdapter.h"
#import <ReactiveObjC/ReactiveObjC.h>

typedef NS_ENUM(NSInteger, WVRMineCellType) {
    
    WVRMineCellTypeAvater,
    WVRMineCellTypeLocal,
    WVRMineCellTypeCollection,
    WVRMineCellTypeReward,
    WVRMineCellTypeFeedBack,
    WVRMineCellTypeOfficel,
    WVRMineCellTypeHelper,
    WVRMineCellTypeSocre,
    WVRMineCellTypeAbount,
    
//    WVRMineCellTypeLogin = 100,
//    WVRMineCellTypeRegister = 101,
//    WVRMineCellTypeEdite = 102,
    WVRMineCellTypeSetting = 103,
};


@interface WVRMineViewModel : WVRViewModel

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;

@property (nonatomic, strong) WVRTableViewAdapter * gTableViewAdapter;

@property (nonatomic, strong) RACSubject * updateModelSingal;

@property (nonatomic, strong, readonly) RACSignal * gotoSignal;

@property (nonatomic, strong, readonly) RACSignal * avatarClickSignal;
//@property (nonatomic, strong) RACSignal * gotoCollectionSignal;
//@property (nonatomic, strong) RACSignal * gotoRewardSignal;
//@property (nonatomic, strong) RACSignal * gotoFeedBackSignal;
//@property (nonatomic, strong) RACSignal * gotoOfficelSignal;
//@property (nonatomic, strong) RACSignal * gotoHeplerSignal;
//@property (nonatomic, strong) RACSignal * gotoScoreSignal;
//@property (nonatomic, strong) RACSignal * gotoAbountSignal;


- (void)fetchData;

@end
