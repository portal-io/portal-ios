//
//  SQZeroSpaceCollVFlowLayout.m
//  youthGo
//
//  Created by qbshen on 16/4/7.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQGroupIconSpaceCollVFlowLayout.h"

@implementation SQGroupIconSpaceCollVFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect]; //mutableCopy];
    //    for (UICollectionViewLayoutAttributes *attr in attributes) {
    //        NSLog(@"%@", NSStringFromCGRect([attr frame]));
    //    }
    //从第二个循环到最后一个
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = COLLECT_CELL_MIN_SPACING_GROUP_ICON;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}

@end
