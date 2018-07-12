//
//  BaseBackForResultDelegate.h
//  soccernotes
//
//  Created by sqb on 15/6/26.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 test
 */


@protocol BaseBackForResultDelegate <NSObject>
-(void)backForResult:(id)info resultCode:(NSInteger)resultCode;

@end
