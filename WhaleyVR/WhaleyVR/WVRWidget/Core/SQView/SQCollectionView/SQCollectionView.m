//
//  SQCollectionView.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/15.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQCollectionView.h"
#import "WVRAppContextHeader.h"

@interface SQCollectionView ()

@end


@implementation SQCollectionView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateWithSectionIndex:(NSInteger)sectionIndex {
    
    [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndex, 1)]];
}

- (void)fillData:(id )args {
    
    
}

- (void)dealloc {
    
    DebugLog(@"");
}


@end
