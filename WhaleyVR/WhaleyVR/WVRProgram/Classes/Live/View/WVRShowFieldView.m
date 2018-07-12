//
//  WVRShowFieldView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/2/14.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRShowFieldView.h"
#import "WVRShowFieldModel.h"
//#import <SDWebImage/SDCycleScrollView.h>
#import "WVRShowFieldCell.h"

#import "SQRefreshHeader.h"

#import "WVRGotoNextTool.h"

#import "WVRLiveShowModel.h"
#import "WVRHomePageCollectionView.h"

@interface WVRShowFieldView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//SDCycleScrollViewDelegate

@property (nonatomic, strong) UIImage *curDotImg;
@property (nonatomic, strong) UIImage *otherDotImg;
@property (nonatomic, weak) WVRHomePageCollectionView *conView;
@property (nonatomic, strong) NSArray<WVRShowFieldRoomModel *> *bannerArray;
@property (nonatomic, strong) NSArray<WVRShowFieldRoomData *> *listArray;

@property (nonatomic, copy) NSString *posId;

@property (atomic, assign) int requestCount;

@end


@implementation WVRShowFieldView

#define kShowFieldBannerId   @"kShowFieldBannerId"
#define kShowFieldListCellId @"kShowFieldListCellId"

+ (instancetype)createWithFrame:(CGRect)frame info:(NSDictionary *)info {
    
    return [[WVRShowFieldView alloc] initWithFrame:frame info:info];
}

- (instancetype)initWithFrame:(CGRect)frame info:(NSDictionary *)info {
    self = [super init];
    if (self) {
        
        [self configSelfWithInfo:info];
        [self configSubviews];
    }
    return self;
}

- (void)configSelfWithInfo:(NSDictionary *)info {
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGSize dotSize = CGSizeMake(adaptToWidth(10), adaptToWidth(2));
    self.curDotImg = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.8] size:dotSize];
    self.otherDotImg = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.4] size:dotSize];
    
    self.posId = info[@"posId"];        // 初始化网络请求所需数据
}

- (void)configSubviews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, adaptToWidth(400));
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, adaptToWidth(104));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    WVRHomePageCollectionView *collectionView = [[WVRHomePageCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[WVRShowFieldCell class] forCellWithReuseIdentifier:kShowFieldListCellId];
//    [collectionView registerClass:[SDCycleScrollView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShowFieldBannerId];
    
    [self addSubview:collectionView];
    self.conView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(collectionView.superview);
        make.height.equalTo(collectionView.superview);
    }];
    
    kWeakSelf(self);
    self.conView.mj_header = [SQRefreshHeader headerWithRefreshingBlock:^{
        
        [weakself refreshData];
    }];
}

#pragma mark - external func

- (void)updateFrame:(CGRect)frame {
    
    self.frame = frame;
}

- (void)refreshData {
    
    [self requestData];
}

#pragma mark - getter

- (BOOL)isLoaded {
    
    return _listArray && _bannerArray;
}

- (void)sendMessageToUnity:(WVRShowFieldRoomData *)model {
    
    WVRLiveShowModel * showModel = [[WVRLiveShowModel alloc] init];
    
    showModel.liveStatus = model.status;
    showModel.roomId = model.roomid;
    showModel.linkArrangeType = LINKARRANGETYPE_SHOW;
    
    [WVRGotoNextTool gotoNextVC:showModel nav:nil];
}

//#pragma mark - SDCycleScrollViewDelegate
//
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//
//    WVRShowFieldRoomModel *model = [_bannerArray objectAtIndex:index];
//
//    [self sendMessageToUnity:model.roomdata];
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRShowFieldRoomData *model = [_listArray objectAtIndex:indexPath.row];
    
    [self sendMessageToUnity:model];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WVRShowFieldRoomData *model = _listArray[indexPath.row];
    
    WVRShowFieldCell *cell = (WVRShowFieldCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kShowFieldListCellId forIndexPath:indexPath];
    [cell fillInfo:model];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        if (indexPath.section == 0) {
//            SDCycleScrollView *headerViewBanner = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kShowFieldBannerId forIndexPath:indexPath];
//            
//            headerViewBanner.delegate = self;
//            headerViewBanner.autoScrollTimeInterval = 4;
//            headerViewBanner.placeholderImage = [UIImage imageNamed:@"defaulf_holder_image"];
//            headerViewBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//            headerViewBanner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//            headerViewBanner.currentPageDotImage = self.curDotImg;
//            headerViewBanner.pageDotImage = self.otherDotImg;
//            
//            if (_listArray.count > 0) {
//                
//                NSMutableArray *urls = [NSMutableArray array];
//                
//                for (WVRShowFieldRoomModel *item in _bannerArray) {
//                    
//                    NSString *imgURL = [(item.titlepic ?: @"") stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                    [urls addObject:imgURL];
//                }
//                if (urls.count > 0) {
//                    headerViewBanner.imageURLStringsGroup = urls;
//                }
//                headerViewBanner.hidden = NO;
//            }else{
//                headerViewBanner.hidden = YES;
//            }
//            
//            return headerViewBanner;
//        }
//    }
//    
//    return nil;
//}

#pragma mark - request

- (void)requestData {
    
    kWeakSelf(self);
    
    self.requestCount = 0;
    
    if (!_listArray.count && !_bannerArray.count) {
        [self showProgress];
    }
    
    // TODO: 确认是否要在数据解析时过滤直播后状态的数据
    [WVRShowFieldModel requestForShowFieldList:^(id responseObj, NSError *error) {
        
        if (responseObj) {
            weakself.listArray = responseObj;
            [weakself requestSuccess];
        } else {
            [weakself netError];
        }
    }];
    
    [WVRShowFieldModel requestForShowFieldBannerList:^(id responseObj, NSError *error) {
        
        if (responseObj) {
            weakself.bannerArray = responseObj;
            [weakself requestSuccess];
        } else {
            [weakself netError];
        }
    }];
}

- (void)requestSuccess {
    
    self.requestCount += 1;
    if (self.requestCount >= 2) {
        
        [self hideProgress];
        
        [self.conView reloadData];
        [self.conView.mj_header endRefreshing];
    }
}

- (void)netError {
    
    [self hideProgress];
    
    if (self.bannerArray.count>0||self.listArray.count>0) {
        SQToastInKeyWindow(kNoNetAlert);
        return;
    }
    kWeakSelf(self);
    [self.conView showNetErrorVWithreloadBlock:^{
        [weakself requestData];
    }];
}

@end
