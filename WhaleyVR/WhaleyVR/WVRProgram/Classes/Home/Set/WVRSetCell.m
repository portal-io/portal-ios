//
//  WVRCollectionCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/5.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRSetCell.h"

@interface WVRSetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UIView *topV;

@end
@implementation WVRSetCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleL.font = kFontFitForSize(17.0f);
    self.countL.font = kFontFitForSize(13.0f);
//    self.titleL.shadowColor = [UIColor redColor];//shadowColor阴影颜色
//    self.titleL.shadowOffset = CGSizeMake(0,adaptToWidth(5));//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    self.titleL.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//    self.titleL.shadowRadius = adaptToWidth(5);//阴影半径，默认3
    
}

-(void)fillData:(SQBaseTableViewInfo *)info
{
    WVRSetCellInfo* cellInfo = (WVRSetCellInfo*)info;
    
    
    [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:cellInfo.sectionModel.thubImageUrl] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageDownloaderHandleCookies completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(error){
            NSString * str = cellInfo.sectionModel.thubImageUrl;
            if ([cellInfo.sectionModel.thubImageUrl containsString:@"/zoom"]) {
                str = [[cellInfo.sectionModel.thubImageUrl componentsSeparatedByString:@"/zoom"] firstObject];
            }
            [self.iconIV wvr_setImageWithURL:[NSURL URLWithString:str] placeholderImage:HOLDER_IMAGE options:SDWebImageRetryFailed|SDWebImageLowPriority];
        }
    }];
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cellInfo.sectionModel.name];
//    NSShadow *shadow = [[NSShadow alloc]init];
//    shadow.shadowBlurRadius = 1.0;
//    shadow.shadowOffset = CGSizeMake(2, 2);
//    shadow.shadowColor = [UIColor redColor];
//    
//    [attrString addAttribute:NSShadowAttributeName
//                              value:shadow
//                              range:NSMakeRange(0, cellInfo.sectionModel.name.length)];
    self.titleL.text = cellInfo.sectionModel.name;
    self.countL.text = [cellInfo.sectionModel.itemCount stringByAppendingString:@"个视频"];
}

-(void)didHighlight
{
    self.titleL.hidden = YES;
    self.countL.hidden = YES;
    self.topV.hidden = YES;
}

-(void)didUnhighlight
{
    self.titleL.hidden = NO;
    self.countL.hidden = NO;
    self.topV.hidden = NO;
}


@end

@implementation WVRSetCellInfo

@end
