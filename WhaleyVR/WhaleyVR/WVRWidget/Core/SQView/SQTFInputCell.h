//
//  SQTFInputCell.h
//  WhaleyVR
//
//  Created by qbshen on 2016/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface SQTFInputCellInfo : SQTableViewCellInfo
@property (nonatomic) NSString * placeHolder;
@property (nonatomic) NSString * content;

@property (copy) void(^endInputBlock)(NSString*);
@end
@interface SQTFInputCell : SQBaseTableViewCell<UITextFieldDelegate>
@property (weak,nonatomic) UITextField *inputTF;

@end
