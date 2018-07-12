//
//  SQCollectionViewDelegate.h
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/14.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SQBaseCollectionViewInfo : NSObject

@property (nonatomic) NSString * cellNibName;
@property (nonatomic) NSString * cellClassName;
@property (nonatomic) NSInteger cellIndex;
@property (nonatomic) CGSize cellSize;
@property (nonatomic, copy) void(^gotoNextBlock)(id);

@property (nonatomic) id viewTag;
@property (nonatomic) BOOL needRefresh;

@property (nonatomic) id args;

@property (nonatomic, weak) id delegate;

@end


@interface SQCollectionViewHeaderInfo : SQBaseCollectionViewInfo

@end


@interface SQCollectionViewFooterInfo : SQBaseCollectionViewInfo

@end


@interface SQCollectionViewSectionInfo : NSObject

@property (nonatomic) NSInteger sectionIndex;
@property (nonatomic) SQCollectionViewHeaderInfo * headerInfo;
@property (nonatomic) SQCollectionViewFooterInfo * footerInfo;
@property (nonatomic) NSArray * cellDataArray;
@property (nonatomic) NSArray * originDataArray;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGFloat minItemSpace;
@property (nonatomic) CGFloat minLineSpace;

//@property (nonatomic, weak) UIViewController * viewController;
//@property (nonatomic, weak) UICollectionView * collectionView;

@end


@interface SQCollectionViewCellInfo : SQBaseCollectionViewInfo

@end


@interface SQBaseCollectionViewCell : UICollectionViewCell

- (void)fillData:(SQBaseCollectionViewInfo *)info;

- (void)didHighlight;
- (void)didUnhighlight;

@end


@interface SQBaseCollectionReusableHeader : UICollectionReusableView

- (void)fillData:(SQBaseCollectionViewInfo *)info;

@end


@interface SQBaseCollectionReusableFooter : UICollectionReusableView

- (void)fillData:(SQBaseCollectionViewInfo *)info;
- (void)updateButtonEdgeInsets:(UIButton *)btn;

@end


@interface SQCollectionViewDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) void(^scrollBottomBlock)(BOOL);
@property (nonatomic, copy) void(^scrollWillEndDragBlock)(CGFloat y);
@property (nonatomic, copy) void(^scrollDidToTop)(BOOL);
@property (nonatomic, copy) void(^scrollDidScrolling)(CGFloat y);
@property (nonatomic, copy) void(^DidEndDecelerating)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^WillBeginDragging)(UIScrollView *scrollView);

@property (nonatomic) BOOL isBottom;

- (void)loadData:(NSDictionary *)data;

@end
