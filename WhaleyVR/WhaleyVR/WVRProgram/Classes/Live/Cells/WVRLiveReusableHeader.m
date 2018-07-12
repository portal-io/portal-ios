//
//  WVRLiveReusableHeader.m
//  WhaleyVR
//
//  Created by qbshen on 2016/12/6.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveReusableHeader.h"
#import "WVRSwipeableView.h"
#import "WVRSwipeSubView.h"
#import "WVRLiveItemModel.h"

@interface WVRLiveReusableHeader ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, WVRSwipeSubViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgBottomV;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet WVRSwipeableView *swipeView;
@property (nonatomic) NSMutableArray * pageViews;
@property (nonatomic) NSMutableArray * subViewInfos;
@property (nonatomic) NSUInteger imageStrIndex;
@property (nonatomic) NSUInteger pageViewIndex;

@property (nonatomic) WVRLiveReusableHeaderInfo * cellInfo;
- (IBAction)livingOnClick:(id)sender;
- (IBAction)reviewOnClick:(id)sender;
- (IBAction)reserveCalendarOnClick:(id)sender;

@end


@implementation WVRLiveReusableHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.swipeView.numberOfActiveViews = 0;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.swipeView.allowedDirection = ZLSwipeableViewDirectionAll;
    self.bgBottomV.layer.masksToBounds = YES;
    self.bgBottomV.layer.cornerRadius = fitToWidth(80.0f);
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bgImageV.height)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.alpha = 1;
//    toolBar.translucent = YES;
    [self.bgImageV addSubview:toolBar];
    
    self.swipeView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.swipeView.layer.shadowOffset = CGSizeMake(0,adaptToWidth(5));//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.swipeView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.swipeView.layer.shadowRadius = adaptToWidth(5);//阴影半径，默认3
    
//    // 当传入参数为正方形时，绘制出的内切图形就是圆，为矩形时画出的就是椭圆
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, self.height-fitToWidth(139), self.width,fitToWidth(139))];
//
//    //配置属性
//    [[UIColor yellowColor] setFill];    //设置填充颜色
//    [[UIColor redColor] setStroke];     //设置描边颜色
//
//    path.lineWidth = 3;     //设置线宽
//
//    //渲染
//    [path stroke];
//    [path fill];
}

- (void)fillData:(SQBaseCollectionViewInfo *)info {
    
    if (self.cellInfo != info) {
        self.cellInfo = (WVRLiveReusableHeaderInfo*)info;
        [self updateData];
    }
}

- (void)updateData {
    
    self.pageViewIndex = 0;
    self.imageStrIndex = 0;
    if(!self.subViewInfos){
        self.subViewInfos = [NSMutableArray array];
    }
    [self.subViewInfos removeAllObjects];
    for (WVRLiveItemModel * itemModel in self.cellInfo.itemModels) {
        WVRSwipeSubViewInfo * subVInfo = [WVRSwipeSubViewInfo new];
        subVInfo.imageStr = itemModel.thubImageUrl;
        subVInfo.name = itemModel.name;
        subVInfo.derscStr = [itemModel.viewCount stringByAppendingString:@"人正在看"];
        [self.subViewInfos addObject:subVInfo];
    }
    if (self.subViewInfos.count>0) {
        WVRSwipeSubViewInfo * info = self.subViewInfos[0];
        [self.bgImageV wvr_setImageWithURL:[NSURL URLWithString:info.imageStr] placeholderImage:HOLDER_IMAGE];
    }
    self.swipeView.numberOfActiveViews = 4;
    if (!self.pageViews) {
        self.pageViews = [NSMutableArray array];
    }
    if (self.pageViews.count != self.swipeView.numberOfActiveViews*2) {
        [self.pageViews removeAllObjects];
        for (int i = 0; i <= self.swipeView.numberOfActiveViews*2; i++) {
            WVRSwipeSubView * subView = (WVRSwipeSubView *)VIEW_WITH_NIB(NSStringFromClass([WVRSwipeSubView class]));
            subView.delegate = self;
            [self.pageViews addObject:subView];
        }
    }
    [self.swipeView discardAllViews];
    [self.swipeView loadViewsIfNeeded];
}


#pragma mark - WVRSwipeSubViewDelegate

- (void)didSelectItem:(WVRSwipeSubView *)view {
    
    NSLog(@"didSelect: %lu",(unsigned long)self.imageStrIndex);
    if (self.cellInfo.itemDidSelectBlock) {
        self.cellInfo.itemDidSelectBlock(view.tag);
    }
}
#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(WVRSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(WVRSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(WVRSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    
//    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(WVRSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    
//    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
//          translation.x, translation.y);
    for (UIView * cur in swipeableView.activeViews) {
        if (cur == view) {
            continue;
        }
        [swipeableView animateViewSwipping:cur index:[swipeableView.activeViews indexOfObject:cur] views:nil swipeableView:swipeableView scale:fabs(translation.x/SCREEN_WIDTH)];
    }
}

- (void)swipeableView:(WVRSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
    [swipeableView loadViewsIfNeeded];
    WVRSwipeSubViewInfo * info = self.subViewInfos[swipeableView.topView.tag];
    
//    kWeakSelf(self);
    [self.bgImageV wvr_setImageWithURL:[NSURL URLWithString:info.imageStr] placeholderImage:HOLDER_IMAGE];
    
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            CIContext *context = [CIContext contextWithOptions:nil];
//            CIImage *ciImage = [CIImage imageWithCGImage:self.bgImageV.image.CGImage];
//            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//            [filter setValue:ciImage forKey:kCIInputImageKey];
//            //设置模糊程度
//            [filter setValue:@30.0f forKey: @"inputRadius"];
//            CIImage *result = [filter valueForKey:kCIOutputImageKey];
//            CGRect frame = [ciImage extent];
//            NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//            CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
//            UIImage * blurImage = [UIImage imageWithCGImage:outImage];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.bgImageV.image = blurImage;
//            });
//        });
//    }];
    for (UIView * cur in swipeableView.activeViews) {
        if (cur == view) {
            continue;
        }
        [swipeableView animateViewSwipping:cur index:[swipeableView.activeViews indexOfObject:cur] views:nil swipeableView:swipeableView scale:0];
    }
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(WVRSwipeableView *)swipeableView {
    if (self.imageStrIndex >= self.subViewInfos.count) {
        self.imageStrIndex = 0;
    }
    if(self.pageViewIndex>=self.pageViews.count){
        self.pageViewIndex = 0;
    }
    WVRSwipeSubView * view = self.pageViews[self.pageViewIndex];
    if (self.subViewInfos.count>self.imageStrIndex) {
        [view fillData:self.subViewInfos[self.imageStrIndex]];
        view.tag = self.imageStrIndex;
    }
    view.frame = CGRectMake(0, 0, swipeableView.frame.size.width, swipeableView.frame.size.height);
    view.transform = CGAffineTransformMakeTranslation(0, 0);
    self.imageStrIndex++;
    self.pageViewIndex++;
    return view;
}



- (IBAction)livingOnClick:(id)sender {
    
    if (self.cellInfo.livingBlock) {
        self.cellInfo.livingBlock();
    }
}


- (IBAction)reserveCalendarOnClick:(id)sender {
    if (self.cellInfo.reserveCalendarBlock) {
        self.cellInfo.reserveCalendarBlock();
    }
}

- (IBAction)reviewOnClick:(id)sender {
    if (self.cellInfo.reviewBlock) {
        self.cellInfo.reviewBlock();
    }
}

@end


@implementation WVRLiveReusableHeaderInfo

@end
