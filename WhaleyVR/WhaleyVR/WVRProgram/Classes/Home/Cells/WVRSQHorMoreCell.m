//
//  WVRSQHorMoreCell.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/18.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRSQHorMoreCell.h"

@interface WVRSQHorMoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end


@implementation WVRSQHorMoreCell

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    self.nameL.text = [(WVRSQHorMoreCellInfo*)info name];
}
@end


@implementation WVRSQHorMoreCellInfo

@end
