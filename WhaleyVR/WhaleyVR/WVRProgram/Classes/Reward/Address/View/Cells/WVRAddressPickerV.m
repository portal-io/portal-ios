//
//  WVRAddressPickerV.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/11.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRAddressPickerV.h"

#define ROW_START (1)

@interface WVRAddressPickerV ()<UIPickerViewDelegate,UIPickerViewDataSource>

- (IBAction)completeBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *addressPicker;

@property (nonatomic) WVRAddressPickerVInfo * originInfo;

@property (nonatomic) SNBasePlaceInfo* selectPlaceInfo;

@end


@implementation WVRAddressPickerV

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray * cons = self.constraints;
    for (NSLayoutConstraint* constraint in cons) {
        //据底部0
        constraint.constant = fitToWidth(constraint.constant);
    }
    self.addressPicker.delegate = self;
    self.addressPicker.dataSource = self;
}

- (void)reloadData
{
    [self.addressPicker reloadAllComponents];
}

- (void)fillData:(WVRAddressPickerVInfo*)info
{
    self.originInfo = info;
    self.selectPlaceInfo = self.originInfo.pickDataArr[ROW_START];
    [self reloadData];
    [self.addressPicker selectRow:ROW_START inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.originInfo.pickDataArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SNBasePlaceInfo * info = self.originInfo.pickDataArr[row];
    return info.name;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    SNBasePlaceInfo * info = self.originInfo.pickDataArr[row];
//    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0], NSFontAttributeName, nil];
//    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithString:info.name attributes:dict];
//    return attributeStr;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row<ROW_START){
        [pickerView selectRow:ROW_START inComponent:component animated:YES];
        self.selectPlaceInfo = self.originInfo.pickDataArr[ROW_START];
        return;
    }
    self.selectPlaceInfo = self.originInfo.pickDataArr[row];
}

- (IBAction)completeBtnOnClick:(id)sender {
    if (self.originInfo.completeBlock) {
        self.originInfo.completeBlock(self.selectPlaceInfo);
    }
}

@end


@implementation WVRAddressPickerVInfo

@end
