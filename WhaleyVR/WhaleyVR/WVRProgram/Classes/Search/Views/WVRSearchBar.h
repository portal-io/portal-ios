//
//  WVRSearchBar.h
//  WhaleyVR
//
//  Created by zhangliangliang on 9/23/16.
//  Copyright © 2016 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WVRSearchBarDelegate <NSObject>

- (void)showSearchHistory;
- (void)searchButtonClickedWithKeyWord:(NSString *)keyword;

@end


@interface WVRSearchBar : UIView

@property (nonatomic, weak) id<WVRSearchBarDelegate> delegate;

- (void)setSearchText:(NSString *)keyword;
- (void)setPlaceholder:(NSString *)holderStr;

-(void)showKeyboard;

-(NSString*)getCurText;

@end
