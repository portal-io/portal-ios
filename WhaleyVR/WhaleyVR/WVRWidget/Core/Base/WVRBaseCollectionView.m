//
//  WVRBaseCollectionView.m
//  WhaleyVR
//
//  Created by qbshen on 2017/1/9.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRBaseCollectionView.h"
#import "WVRNullCollectionViewCell.h"
#import "SQRefreshHeader.h"
#import "SQRefreshFooter.h"
#import "UIColor+Extend.h"
#import "WVRAppContextHeader.h"
#import "SQToastTool.h"
#import "WVRWidgetToastHeader.h"
#import "UIView+Extend.h"

@interface WVRBaseCollectionView ()

@property (nonatomic, strong) WVRNullCollectionViewCell* mNullView;

@end


@implementation WVRBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = k_Color10;
    }
    return self;
}

#pragma mark - errorView and nullView

- (void)showToast:(NSString *)content {
    
}

- (void)addHeaderRefresh:(void(^)(void))refreshBlock {
    
    if (self.mj_header) {
        [self.mj_header beginRefreshingWithCompletionBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
    } else {
        self.mj_header = [SQRefreshHeader headerWithRefreshingBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
    }
}

- (void)addFooterMore:(void(^)(void))moreBlock {
    
    if (self.mj_footer) {
        [self.mj_footer beginRefreshingWithCompletionBlock:^{
            if (moreBlock) {
                moreBlock();
            }
        }];
    } else {
        self.mj_footer = [SQRefreshFooter footerWithRefreshingBlock:^{
            if (moreBlock) {
                moreBlock();
            }
        }];
    }
}

- (void)stopHeaderRefresh {
    
    [self.mj_header endRefreshing];
}

- (void) stopFooterMore:(BOOL)noMore; {
    
    if (noMore) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer endRefreshing];
    }
}

- (void)bindData:(id)originData {
    
}

- (void)updateWithSectionIndex:(NSInteger)sectionIndex {
    
    [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndex, 1)]];
}

- (void)dealloc {
    
    DebugLog(@"");
}

#pragma mark - Protocol

- (void)bindViewModel:(id)viewModel {
    
}

- (nullable NSIndexPath *)dataSourceIndexPathForPresentationIndexPath:(nullable NSIndexPath *)presentationIndexPath {
    
    return nil;
}

- (NSInteger)dataSourceSectionIndexForPresentationSectionIndex:(NSInteger)presentationSectionIndex {
    
    return 0;
}

- (void)performUsingPresentationValues:(nonnull void (^)(void))actionsToTranslate {
    
}

- (nullable NSIndexPath *)presentationIndexPathForDataSourceIndexPath:(nullable NSIndexPath *)dataSourceIndexPath {
    
    return nil;
}

- (NSInteger)presentationSectionIndexForDataSourceSectionIndex:(NSInteger)dataSourceSectionIndex {
    
    return 0;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

+ (nonnull instancetype)appearance {
    
    return [[WVRBaseCollectionView alloc] init];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
    
    return [[WVRBaseCollectionView alloc] init];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    
    return [[WVRBaseCollectionView alloc] init];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    
    return [[WVRBaseCollectionView alloc] init];
}

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    
    return [[WVRBaseCollectionView alloc] init];
}

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    
    return [[WVRBaseCollectionView alloc] init];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    
    return CGPointZero;
}

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    
    return CGPointZero;
}

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    
    return CGRectZero;
}

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    
    return CGRectZero;
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    
    return NO;
}

- (void)updateFocusIfNeeded {
    
}

@end


//@implementation WVRBaseCollectionViewInfo
//
//@end
