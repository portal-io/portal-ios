//
//  SQTableViewDelegate.h
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, SQTableViewSectionStyle){
    SQTableViewSectionStyleFir = 0,
    SQTableViewSectionStyleSec,
    SQTableViewSectionStyleThi,
    SQTableViewSectionStyleFou,
};

@interface SQBaseTableViewInfo : NSObject

@property (nonatomic) NSString * cellNibName;
@property (nonatomic) NSString * cellClassName;
@property UITableViewCellStyle cellStyle;
@property NSIndexPath *indexPath;
@property (copy) void(^gotoNextBlock)(id);
@property (nonatomic, copy) void(^deselectBlock)(id);
@property CGFloat cellWidth;
@property CGFloat cellHeight;

@property id args;

@end


@interface SQTableViewHeadViewInfo : SQBaseTableViewInfo

@end


@interface SQTableViewFootViewInfo : SQBaseTableViewInfo

@end

@interface SQTableViewSectionInfo : NSObject

@property (nonatomic) SQTableViewHeadViewInfo * headViewInfo;
@property (nonatomic) SQTableViewFootViewInfo * footViewInfo;
@property (nonatomic) NSMutableArray * cellDataArray;
@property (nonatomic) BOOL isOpen;

@end


#define CELL_HIEGHT_DEFAULT (44.0)
#define CELL_HIEGHT_ZERO (0.0)

@interface SQTableViewCellInfo : SQBaseTableViewInfo

@property (nonatomic, copy) BOOL(^willDeleteBlock)(id);

@end


@interface SQBaseTableViewCell : UITableViewCell

- (void)fillData:(SQBaseTableViewInfo *)info;
- (void)updateTableView:(SQBaseTableViewInfo *)info animal:(UITableViewRowAnimation)animal;

- (void)didHighlight;

- (void)didUnhighlight;

@end


@interface SQBaseTableViewSectionView : UIView

- (void)fillData:(SQBaseTableViewInfo*)info;
- (void)updateTableView:(SQBaseTableViewInfo*)info animal:(UITableViewRowAnimation)animal;

- (void)didHighlight;

- (void)didUnhighlight;

@end


@protocol SQTableViewSectionProtocol <NSObject>

@required
- (void)fillData:(SQBaseTableViewInfo*)info;

@optional
- (void)updateTableView:(SQBaseTableViewInfo*)info animal:(UITableViewRowAnimation)animal;

- (void)didHighlight;

- (void)didUnhighlight;

@end


@interface SQTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^didScrollBlock)(void);
@property (nonatomic, copy) void(^didEndScrollBlock)(void);
@property (nonatomic) BOOL canEdit;
@property (nonatomic) UITableViewCellEditingStyle editStyle;
@property (nonatomic) NSMutableArray * sectionTitles;

- (void)loadData:(NSDictionary *(^)(void))loadDataBlock;

@end
