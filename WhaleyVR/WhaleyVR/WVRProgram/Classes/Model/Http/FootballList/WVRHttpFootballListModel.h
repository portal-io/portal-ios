//
//  WVRHttpFootballListModel.h
//  WhaleyVR
//
//  Created by qbshen on 2017/5/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WVRHttpFootballTeamModel : NSObject

@end


@interface WVRHttpFootballModel : NSObject
/*
 Behavior = "replay://replay?MatchID=1";
 Description = 123123;
 Img = "";
 Location = "\U8679\U53e3\U8db3\U7403\U573a";
 MatchID = 1;
 Score =     (
 1,
 0
 );
 */
@property (nonatomic, strong) NSString * Behavior;
@property (nonatomic, strong) NSString * Description;
@property (nonatomic, strong) NSString * Img;
@property (nonatomic, strong) NSString * Location;
@property (nonatomic, strong) NSString * MatchID;
@property (nonatomic, strong) NSArray * Score;
@property (nonatomic, strong) NSArray<WVRHttpFootballTeamModel*> * Teams;

@end


@interface WVRHttpFootballADModel : NSObject

@property (nonatomic, strong) NSArray<WVRHttpFootballADModel*> * Ad;
@property (nonatomic, strong) NSString * Img;
@property (nonatomic, strong) NSString * H5;

@end


@interface WVRHttpFootballListModel : NSObject

@property (nonatomic, strong) WVRHttpFootballModel * Trailer;

@property (nonatomic, strong) WVRHttpFootballModel * Live;

@property (nonatomic, strong) NSArray<WVRHttpFootballADModel *> * Ad;

@property (nonatomic, strong) NSArray<WVRHttpFootballModel *>* Replay;

@end
