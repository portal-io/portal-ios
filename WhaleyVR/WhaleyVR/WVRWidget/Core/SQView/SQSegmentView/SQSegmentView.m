//
//  LWSegmentView.m
//  LewoSVR
//
//  Created by sqb on 15/11/13.
//  Copyright © 2015年 Snailvr. All rights reserved.
//

#import "SQSegmentView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface SQSegmentView ()

@property (weak, nonatomic) IBOutlet UIView *view;

@end


@implementation SQSegmentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        VIEW_WITH_NIB([WVRSQDownView description]);
        [self setup];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
////        [self setStyle];
//    }
//    return self;
//}

- (void)setup {
    
    [[NSBundle mainBundle] loadNibNamed:@"SQSegmentView" owner:self options:nil];
    
    [self addSubview:self.view];
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
////    [self setStyle];
//}

//- (void)setStyle {
//    self.borderType = HMSegmentedControlBorderTypeNone;
//    self.verticalDividerEnabled = NO;
//    self.segmentEdgeInset = UIEdgeInsetsMake(0, fitToWidth(15.0f), 0, fitToWidth(15.0f));
//    self.selectionIndicatorColor = UIColorFromRGB(0x00aeff);
//    self.selectedTitleTextAttributes = @{(NSForegroundColorAttributeName):UIColorFromRGB(0x1e9ef4),(NSFontAttributeName):[UIFont systemFontOfSize:15]};
//    
//    self.titleTextAttributes = @{(NSForegroundColorAttributeName):UIColorFromRGB(0x898989),(NSFontAttributeName):[UIFont systemFontOfSize:15]};
//    self.selectionIndicatorHeight = 0.0f;
//    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    self.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
//    self.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
//}

- (void)setItemTitles:(NSArray<NSString *> *)itemTitles
        andScrollView:(UIScrollView *)scrollView
        selectedBlock:(WMNavTabBarBlock)block {
    
    [super setItemTitles:itemTitles andScrollView:scrollView selectedBlock:block];
}

//- (instancetype)initWithSectionTitles:(NSArray *)titles {
////  self = [super initWithSectionTitles:titles];
//    if (self) {
////        [self setStyle];
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self displayCurrentModleProperty];
}

- (void)displayCurrentModleProperty {
        
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self superclass], &count);

    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        // 属性名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ivarName = [ivarName substringFromIndex:1];
        if ([ivarName isEqualToString:@"selectionIndicatorStripLayer"]) {
            CALayer* Indicatorlayer = object_getIvar(self, ivar);
            Indicatorlayer.masksToBounds = YES;
            Indicatorlayer.cornerRadius = Indicatorlayer.bounds.size.height/2;
        }
    }
    free(ivars);
}

- (CALayer *)_selectionIndicatorStripLayer {
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList([self superclass], &count);
    CALayer* Indicatorlayer = nil;
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        // 属性名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ivarName = [ivarName substringFromIndex:1];
        if ([ivarName isEqualToString:@"selectionIndicatorStripLayer"]) {
            Indicatorlayer = object_getIvar(self, ivar);
        }
    }
    free(ivars);
    return Indicatorlayer;
}

- (UIScrollView *)_scrollView {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self superclass], &count);
    UIScrollView *Indicatorlayer = nil;
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        // 属性名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ivarName = [ivarName substringFromIndex:1];
        if ([ivarName isEqualToString:@"scrollView"]) {
            Indicatorlayer = object_getIvar(self, ivar);
        }
    }
    free(ivars);
    return Indicatorlayer;
}

//- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify
//{
////    [super setSelectedSegmentIndex:index animated:animated notify:notify];
////    return;
////    NSNumber * nub = [NSNumber numberWithInteger:index];
////    NSNumber* oldNum = [self _selectedSegmentIndex];
////    oldNum = nub;
////    [self _selectedSegmentIndex:index];
////    [self setValue:@(index) forKey:@"selectedSegmentIndex"];
//    Ivar ivar = [self _selectedSegmentIndex:index];//class_getInstanceVariable(object_getClass(self), "selectedSegmentIndex");
//    int *age_pointer = (int *)((__bridge void *)(self) + ivar_getOffset(ivar));
//    NSLog(@"age ivar offset = %td", ivar_getOffset(ivar));
//    *age_pointer = index;
//    [self setNeedsDisplay];
//    
//    if (index == HMSegmentedControlNoSegment) {
////        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
//        [[self _selectionIndicatorStripLayer] removeFromSuperlayer];
////        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
//    } else {
////        [self scrollToSelectedSegmentIndex:animated];
//        ((void (*)(id,SEL,BOOL))objc_msgSend)(self,@selector(scrollToSelectedSegmentIndex:), animated);
////        [self performSelector:@selector(scrollToSelectedSegmentIndex:) withObject:@(animated)];
//        
//        if (animated) {
//            // If the selected segment layer is not added to the super layer, that means no
//            // index is currently selected, so add the layer then move it to the new
//            // segment index without animating.
////            if(self.selectionStyle == HMSegmentedControlSelectionStyleArrow) {
////                if ([self.selectionIndicatorArrowLayer superlayer] == nil) {
////                    [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
////                    
////                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
////                    return;
////                }
////            }else {
//                if ([[self _selectionIndicatorStripLayer] superlayer] == nil) {
//                    [[self _scrollView].layer addSublayer:[self _selectionIndicatorStripLayer]];
//                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
//                    return;
//                }
////            }
//            
////            if (notify)
////                [self notifyForSegmentChangeToIndex:index];
//            ((void (*)(id,SEL,NSInteger))objc_msgSend)(self,@selector(notifyForSegmentChangeToIndex:), index);
////            [self performSelector:@selector(notifyForSegmentChangeToIndex:) withObject:@(index)];
//            // Restore CALayer animations
////            self.selectionIndicatorArrowLayer.actions = nil;
//            [self _selectionIndicatorStripLayer].actions = nil;
////            self.selectionIndicatorBoxLayer.actions = nil;
//            
//            // Animate to new position
//            [CATransaction begin];
//            [CATransaction setAnimationDuration:0.15f];
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
////            [self performSelector:@selector(setArrowFrame)];
////            self.selectionIndicatorBoxLayer.frame = [self frameForSelectionIndicator];
////            id ii = objc_msgSend();//objc_msgSend(self, @selector(init));
//            CGRect frame = ((CGRect (*)(id,SEL))objc_msgSend)(self,@selector(setArrowFrame));
//            [self _selectionIndicatorStripLayer].frame = frame;
////
////            [self performSelector:@selector(frameForSelectionIndicator)];
////            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
//            [CATransaction commit];
//        } else {
//            // Disable CALayer animations
////            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
////            self.selectionIndicatorArrowLayer.actions = newActions;
////            [self setArrowFrame];
//            
////            self.selectionIndicatorStripLayer.actions = newActions;
////            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
//            
////            self.selectionIndicatorBoxLayer.actions = newActions;
////            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
//            
////            if (notify)
////                [self notifyForSegmentChangeToIndex:index];
//        }
//    }
//
//}

//- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
//    
//    SEL wk_sel = NSSelectorFromString(@"loadData:MIMEType:characterEncodingName:baseURL:");
//    
//    ((void (*)(id, SEL, id, id, id, id))objc_msgSend)(self, wk_sel, data, MIMEType, textEncodingName, baseURL);
//}

@end
