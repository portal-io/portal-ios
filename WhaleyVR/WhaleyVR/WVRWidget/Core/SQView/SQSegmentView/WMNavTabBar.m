//
//  WMNavTabBar.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMNavTabBar.h"
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"

#define kBarSpeace 10
#define kBarLine 3

// 焦点不在时的颜色
#define kGreyColor (k_Color6)//[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]

#define kColor(r, g, b) [UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha: 1.0]
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define WIDTH_LINE (15.f)

@interface WMNavTabBar () <UIScrollViewDelegate>
{
    UIView *_line;
    NSMutableArray *_itemsBtn;
    NSMutableArray *_itemsWidth;
    
    UIImageView *_shadeLeft;
    UIImageView *_shadeRight;
    
    CGFloat _barSpeace;
    
    CGFloat _curScale;
    BOOL _isPressItem;
    BOOL _dragging;
}

@property (strong, nonatomic) UIScrollView *tabBarScrollView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, copy) WMNavTabBarBlock block;

@end

@implementation WMNavTabBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_tabBarScrollView) {
        _tabBarScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tabBarScrollView.frame = self.bounds;
        
        _shadeLeft.frame = CGRectMake(0, 0, kShadeW, self.frame.size.height);
        _shadeRight.frame = CGRectMake(self.frame.size.width - kShadeW, 0, kShadeW, self.frame.size.height);
        
        if (_isSamp) {
            CGFloat buttonX = 0.0f;
            CGFloat buttonW = self.bounds.size.width / _itemsBtn.count;
            for (UIButton *btn in _itemsBtn) {
                btn.frame = CGRectMake(buttonX, 0, buttonW, self.frame.size.height);
                buttonX += buttonW;
            }
            UIButton *button = _itemsBtn[_currentItemIndex];
            CGFloat width = WIDTH_LINE;//[_itemsWidth[_currentItemIndex] floatValue] - _barSpeace * 2;
            _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
        } else {
            UIButton *button = _itemsBtn[_currentItemIndex];
            CGFloat offsetX = button.center.x - self.frame.size.width * 0.5f;
            if (offsetX < 0.0f) {
                offsetX = 0.0f;
            } else if (offsetX + self.frame.size.width > _tabBarScrollView.contentSize.width) {
                if (_tabBarScrollView.contentSize.width < self.frame.size.width) {
                    offsetX = 0.0f;
                } else {
                    offsetX = _tabBarScrollView.contentSize.width - self.frame.size.width;
                }
            }
            [_tabBarScrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:NO];
        }
    }
}

- (void)initUI
{
    if (!_tabBarScrollView) {
        _tabBarScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _tabBarScrollView.delegate = self;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tabBarScrollView];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = kLineColor;
        [_tabBarScrollView addSubview:_line];
        
        _shadeLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kShadeW, self.frame.size.height)];
        [_shadeLeft setImage:kShadeLeft];
        [self addSubview:_shadeLeft];
        _shadeRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kShadeW, 0, kShadeW, self.frame.size.height)];
        [_shadeRight setImage:kShadeRight];
        [self addSubview:_shadeRight];
    }
}

#pragma mark - Public Methods
- (void)setItemTitles:(NSArray *)itemTitles
        andScrollView:(UIScrollView *)scrollView
        selectedBlock:(WMNavTabBarBlock)block
{
    if (itemTitles.count <= 0) {
        return;
    }
    [self initUI];
    
    _block = block;
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    for (UIButton *btn in _itemsBtn) {
        [btn removeFromSuperview];
    }
    _itemsBtn = [@[] mutableCopy];
    _itemsWidth = [@[] mutableCopy];
    
    CGFloat buttonX = 0.0f;
    CGFloat buttonW = self.bounds.size.width / _itemsBtn.count;
    _barSpeace = _isSamp ? 0 : kBarSpeace;
    for (NSString *title in itemTitles) {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kBarFont]}];
        NSNumber *width = [NSNumber numberWithFloat:size.width + _barSpeace * 2];
        [_itemsWidth addObject:width];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(buttonX, 0, _isSamp ? buttonW : [width floatValue], self.frame.size.height);
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:kBarFont]];
        [button setTitleColor:kGreyColor forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarScrollView addSubview:button];
        [_itemsBtn addObject:button];
        
        buttonX += _isSamp ? buttonW : [width floatValue];
    }
    if (_isSamp) {
        _tabBarScrollView.contentSize = self.frame.size;
        _shadeRight.hidden = TRUE;
    } else {
        _tabBarScrollView.contentSize = CGSizeMake(buttonX, self.frame.size.height);
    }
    [_tabBarScrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    
    _shadeLeft.hidden = TRUE;
    _currentItemIndex = -1;
    self.currentItemIndex = 0;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    if (currentItemIndex > _itemsBtn.count - 1 || currentItemIndex < 0) return;
    if (currentItemIndex != _currentItemIndex) {
        if (_delegate) {
            [_delegate itemDidSelected:self withIndex:currentItemIndex isRepeat:FALSE];
        } else if (_block) {
            _block(currentItemIndex, FALSE);
        }
    }
    _currentItemIndex = currentItemIndex;
    
    NSInteger i = 0;
    for (UIButton *btn in _itemsBtn) {
        [btn setTitleColor:kGreyColor forState:UIControlStateNormal];
        if (_isFont && i != _currentItemIndex) {
            btn.transform = CGAffineTransformMakeScale(kBarFontScale, kBarFontScale);
        }
        i++;
    }
    UIButton *button = _itemsBtn[_currentItemIndex];
    [button setTitleColor:kLineColor forState:UIControlStateNormal];
    if (_isFont) {
        button.transform = CGAffineTransformIdentity;
    }
    if (!_isSamp) {
        CGFloat offsetX = button.center.x - self.frame.size.width * 0.5f;
        if (offsetX < 0.0f) {
            offsetX = 0.0f;
        } else if (offsetX + self.frame.size.width > _tabBarScrollView.contentSize.width) {
            if (_tabBarScrollView.contentSize.width < self.frame.size.width) {
                offsetX = 0.0f;
            } else {
                offsetX = _tabBarScrollView.contentSize.width - self.frame.size.width;
            }
        }
        [_tabBarScrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:YES];
    }
    CGFloat width = WIDTH_LINE;//[_itemsWidth[_currentItemIndex] floatValue] - _barSpeace * 2;
    _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
    _line.layer.masksToBounds = YES;
    _line.layer.cornerRadius = 2;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tabBarScrollView) {
        if (!_isSamp) {
            _shadeLeft.hidden = scrollView.contentOffset.x == 0 ? YES : NO;
            _shadeRight.hidden = ((scrollView.contentOffset.x + self.frame.size.width) >= scrollView.contentSize.width) ? YES : NO;
        }
    } else if (scrollView == _scrollView) {
        if (!_isStop&&!_isPressItem) {
            [self setLinePosition:scrollView.contentOffset.x];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
    _isPressItem = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragging = YES;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if (scrollView == _tabBarScrollView) {
        
    } else if (scrollView == _scrollView) {
        NSInteger targetIndex = (*targetContentOffset).x / scrollView.frame.size.width;
        UIButton *button = _itemsBtn[targetIndex<_itemsBtn.count? targetIndex:_itemsBtn.count-1];
        [self.tabBarScrollView scrollRectToVisible:button.frame animated:YES];
    }
    
//    [self setLinePosition:(*targetContentOffset).x];
    _dragging = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView) {
        if (scrollView.contentOffset.x == 0
            || scrollView.contentOffset.x+scrollView.frame.size.width == scrollView.contentSize.width) {
            self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        }
    }
}

#pragma mark - Private Methods
- (void)setLinePosition_Origin:(CGFloat)position
{
    //for (UIButton *btn in _itemsBtn) {
    //[btn setTitleColor:kGreyColor forState:UIControlStateNormal];
    //}
    NSLog(@"positionx:%f",position);
    NSInteger index = position / self.frame.size.width;
    if (index < _currentItemIndex && index >= 0) {
        CGFloat tt = self.frame.size.width - (position - (index * self.frame.size.width));
        tt /= self.frame.size.width;
        
        UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);
        UIButton *button = _itemsBtn[index];
        [button setTitleColor:color forState:UIControlStateNormal];
        UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
        UIButton *button1 = _itemsBtn[index + 1];
        [button1 setTitleColor:color1 forState:UIControlStateNormal];
        
        if (_isFont) {
            CGFloat scale = kBarFontScale + (1-kBarFontScale) * tt;
            button.transform = CGAffineTransformMakeScale(scale, scale);
            CGFloat scale1 = kBarFontScale + (1-kBarFontScale) * (1-tt);
            button1.transform = CGAffineTransformMakeScale(scale1, scale1);
        }
        
        CGFloat dw = ([_itemsWidth[index] floatValue] + [_itemsWidth[index + 1] floatValue]) * 0.5;
        CGFloat dt = tt > 0.5 ? (1 - tt) : tt;
        dw *= dt;
        
        CGFloat width = ([_itemsWidth[index] floatValue] * tt + [_itemsWidth[index + 1] floatValue] * (1-tt)) - _barSpeace * 2 + dw;
        
        CGFloat x = button1.center.x - width * 0.5 - button.frame.size.width * tt;
        
        CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
        if (x < button.center.x - w * 0.5) {
            x = button.center.x - w * 0.5;
        }
        
        _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
    } else {
        index = (position + self.frame.size.width - 1) / self.frame.size.width;
        if (index > _currentItemIndex && index < _itemsBtn.count) {
            CGFloat tt = (position + self.frame.size.width - 1) - (index * self.frame.size.width);
            tt /= self.frame.size.width;
            
            UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);
            UIButton *button = _itemsBtn[index];
            [button setTitleColor:color forState:UIControlStateNormal];
            UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
            UIButton *button1 = _itemsBtn[index - 1];
            [button1 setTitleColor:color1 forState:UIControlStateNormal];
            
            if (_isFont) {
                CGFloat scale = kBarFontScale + (1-kBarFontScale) * tt;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                CGFloat scale1 = kBarFontScale + (1-kBarFontScale) * (1-tt);
                button1.transform = CGAffineTransformMakeScale(scale1, scale1);
            }
            
            CGFloat dw = ([_itemsWidth[index] floatValue] + [_itemsWidth[index - 1] floatValue]*0.5) * 0.5;//
            CGFloat dt = tt > 0.5 ? (1 - tt) : tt;
            dw *= dt;
            
            CGFloat width = ([_itemsWidth[index - 1] floatValue] *0.5* (tt) + [_itemsWidth[index] floatValue] * tt) - _barSpeace * 2 + dw;//
            CGFloat x = button1.center.x - WIDTH_LINE * 0.5 + button1.frame.size.width * tt;
            
            CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
            if (x > button.center.x - w * 0.5) {
                x = button.center.x - w * 0.5;
            }
//            NSLog(@"x:%f tt:%f width:%f",x,tt,width);
            _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
        }
    }
}

#pragma mark - Private Methods
- (void)setLinePosition:(CGFloat)position
{
    if (position<0||position>self.scrollView.contentSize.width-self.scrollView.frame.size.width) {
        return;
    }
    //for (UIButton *btn in _itemsBtn) {
    //[btn setTitleColor:kGreyColor forState:UIControlStateNormal];
    //}
    NSLog(@"x_position:%f",position);
    CGFloat contentWidth = self.scrollView.frame.size.width;
    NSInteger index = position / contentWidth;
    for (UIButton * cur in _itemsBtn) {
        UIColor *color = kGreyColor;//
        [cur setTitleColor:color forState:UIControlStateNormal];
    }
    if (index < _currentItemIndex && index >= 0) {
        CGFloat tt = contentWidth - (position - (index * contentWidth));
        tt /= contentWidth;
        
        UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);//UIColorFromRGBA(0x29a1f7, tt);//
        UIButton *button = _itemsBtn[index];
        [button setTitleColor:color forState:UIControlStateNormal];
        UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));//UIColorFromRGBA(0x29a1f7, tt);
        UIButton *button1 = _itemsBtn[index + 1];
        [button1 setTitleColor:color1 forState:UIControlStateNormal];
        
        if (_isFont) {
            CGFloat scale = kBarFontScale + (1-kBarFontScale) * tt;
            button.transform = CGAffineTransformMakeScale(scale, scale);
            CGFloat scale1 = kBarFontScale + (1-kBarFontScale) * (1-tt);
            button1.transform = CGAffineTransformMakeScale(scale1, scale1);
        }
        CGFloat distance = button1.center.x - button.center.x-WIDTH_LINE*0.5;
        
        CGFloat width = _line.frame.size.width;//([_itemsWidth[index - 1] floatValue] *0.5* (tt) + WIDTH_LINE + dw);//[_itemsWidth[index] floatValue] * tt) - _barSpeace * 2
        CGFloat x = _line.frame.origin.x ;
        if (x>button.center.x-WIDTH_LINE*0.5+1) {
            //            _curScale = tt;
            //            width = distance*(2*tt)+WIDTH_LINE;
            x -= distance*(tt);
            x = MAX(x, button.center.x-WIDTH_LINE*0.5);
            width += distance*(tt);
            width = MIN(width, button1.center.x-button.center.x+WIDTH_LINE);
        }else if(width>WIDTH_LINE){
            width -= distance*(tt)/10;
            width = MAX(WIDTH_LINE, width);
        }else{
            //                width = WIDTH_LINE;
            //                x = button.center.x -WIDTH_LINE*0.5;
        }

//        if (x>button.center.x-WIDTH_LINE*0.5+1) {
//            //            _curScale = tt;
//            //            width = distance*(2*tt)+WIDTH_LINE;
//            x -= distance*(tt)/20;
//            x = MAX(x, button.center.x-WIDTH_LINE*0.5);
//            width += distance*(tt)/20;
//            width = MIN(width, button1.center.x-button.center.x+WIDTH_LINE);
//        }
//        else{//if(width>WIDTH_LINE){
//            width -= distance*(tt)/20;
//            width = MAX(WIDTH_LINE, width);
//            x = MAX(x, button.center.x-WIDTH_LINE*0.5);
//            //        }else{
//            //                width = WIDTH_LINE;
//            //                x = button.center.x -WIDTH_LINE*0.5;
//        }
        
        _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
    } else {
        index = (position + contentWidth - 1) / contentWidth;
        if (index > _currentItemIndex && index < _itemsBtn.count) {
            CGFloat tt = (position + contentWidth - 1) - (index * contentWidth);
            tt /= contentWidth;
            
            UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);
            UIButton *button = _itemsBtn[index];
            [button setTitleColor:color forState:UIControlStateNormal];
            //            UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
            UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));//UIColorFromRGBA(0x29a1f7, tt);;
            UIButton *button1 = _itemsBtn[index - 1];
            [button1 setTitleColor:color1 forState:UIControlStateNormal];
            
            if (_isFont) {
                CGFloat scale = kBarFontScale + (1-kBarFontScale) * tt;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                CGFloat scale1 = kBarFontScale + (1-kBarFontScale) * (1-tt);
                button1.transform = CGAffineTransformMakeScale(scale1, scale1);
            }
            
            CGFloat distance = button.center.x - button1.center.x-WIDTH_LINE*0.5;
            
            CGFloat width = _line.frame.size.width;//([_itemsWidth[index - 1] floatValue] *0.5* (tt) + WIDTH_LINE + dw);//[_itemsWidth[index] floatValue] * tt) - _barSpeace * 2
            CGFloat x = _line.frame.origin.x ;

//            if (x+width<button.center.x+WIDTH_LINE*0.5) {
//                _curScale = tt;
//                width = distance*(2*tt)+WIDTH_LINE;
//            }else if(width>WIDTH_LINE){
//                x += distance*(tt)/10;
//                x = MIN(x, button.center.x-WIDTH_LINE*0.5);
//                width -= distance*(tt)/10;
//                width = MAX(WIDTH_LINE, width);
//            }else{
//                //                width = WIDTH_LINE;
//                //                x = button.center.x -WIDTH_LINE*0.5;
//            }
            if (x+width<button.center.x+WIDTH_LINE*0.5) {
                _curScale = tt;
                x = MAX(x, button1.centerX-WIDTH_LINE*0.5);
                width = distance*(2*tt)+WIDTH_LINE;
            }else {
                x += distance*(tt)/20;
                x = MIN(x, button.center.x-WIDTH_LINE*0.5);
                width -= distance*(tt)/20;
                width = MAX(WIDTH_LINE, width);
                //            }else{
                //                width = WIDTH_LINE;
                //                x = button.center.x -WIDTH_LINE*0.5;
            }
//            NSLog(@"x:%f tt:%f width:%f",x,tt,width);
            _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
        }
    }
//    NSLog(@"line.width:%f",_line.width);
}

- (void)itemPressed:(UIButton *)button
{
    _isPressItem = YES;
    NSInteger index = [_itemsBtn indexOfObject:button];
    if (index == _currentItemIndex) {
        if (_delegate) {
            [_delegate itemDidSelected:self withIndex:index isRepeat:TRUE];
        } else if (_block) {
            _block(index, TRUE);
        }
    } else {
        if (_scrollView) {
            CGFloat offset = index * _scrollView.frame.size.width;
            [_scrollView setContentOffset:CGPointMake(offset, 0.0f) animated:YES];
        } else {
            if (_delegate) {
                [_delegate itemDidSelected:self withIndex:index isRepeat:FALSE];
            } else if (_block) {
                _block(index, FALSE);
            }
        }
    }
}

@end

