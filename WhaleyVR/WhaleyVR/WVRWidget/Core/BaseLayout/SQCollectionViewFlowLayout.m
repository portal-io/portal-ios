//
//  SNCollectionViewFlowLayout.m
//  soccernotes
//
//  Created by sqb on 15/9/10.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SQCollectionViewFlowLayout.h"

@interface SQCollectionViewFlowLayout ()

/** 所有的布局属性 */
@property (nonatomic, strong) NSArray *attrsArray;

@end
@implementation SQCollectionViewFlowLayout

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.attrsArray) {
        return self.attrsArray;
    }
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect]; //mutableCopy];
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
        NSInteger maximumSpacing = COLLECT_CELL_MIN_SPACING;
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
    self.attrsArray = attributes;
    return self.attrsArray;
}

@end
