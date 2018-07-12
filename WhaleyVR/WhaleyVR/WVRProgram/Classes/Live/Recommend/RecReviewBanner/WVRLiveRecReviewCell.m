//
//  WVRLiveRecReviewCell.m
//  WhaleyVR
//
//  Created by qbshen on 2017/2/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveRecReviewCell.h"
#import "WVRTriangleView.h"
#import "WVRSectionModel.h"

@interface WVRLiveRecReviewCell ()
@property (weak, nonatomic) IBOutlet WVRTriangleView *triangleV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topV_BottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconV_bottom_cons;

@end
@implementation WVRLiveRecReviewCell

-(void)awakeFromNib
{
    [super awakeFromNib];

}

-(void)fillData:(SQBaseCollectionViewInfo *)info
{
    [super fillData:info];
    WVRLiveReviewCellInfo* cellInfo = (WVRLiveReviewCellInfo*)info;
//    NSArray * cons = [self.contentView constraints];
    if ([cellInfo.itemModel.arrangeShowFlag boolValue]) {
        self.topV_BottomCons.constant = fitToWidth(4.f);
        self.iconV_bottom_cons.constant = fitToWidth(4.f);
    }else{
        self.topV_BottomCons.constant = fitToWidth(10.f);
        self.iconV_bottom_cons.constant = fitToWidth(10.f);
    }
    self.triangleV.hidden = ![cellInfo.itemModel.arrangeShowFlag boolValue];
}

//-(void)drawRect:(CGRect)rect
//
//{
//    
//    //设置背景颜色
//    
//    [[UIColor
//      redColor]set];
//    
//    UIRectFill([self
//                
//                bounds]);
//    
//    //拿到当前视图准备好的画板
//    
//    CGContextRef
//    context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    
//    CGContextMoveToPoint(context,
//                         self.width/2, self.height-fitToWidth(7.f+6.f));//设置起点
//    
//    CGContextAddLineToPoint(context,
//                            0, fitToWidth(6.f));
//    
//    CGContextAddLineToPoint(context,
//                            self.width/2-fitToWidth(6.f), self.height);
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor
//      blackColor] setFill]; //设置填充色
//    
//    [[UIColor
//      blueColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context,
//                      kCGPathFillStroke);//绘制路径path
//    
//}

@end
