//
//  WVROrderAlertView.m
//  SureCustomActionSheet
//
//  Created by Bruce on 2017/6/5.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import "WVROrderActionSheet.h"
#import <WVRAppContextHeader.h>
#import <UIView+Extend.h>
#import "WVRMediator+Launcher.h"
#import "WVROrderSWCurrencyHView.h"

@interface WVROrderActionSheet ()<UITableViewDelegate,UITableViewDataSource> {
    
    float _footerHeight;
    float _firstFooterHeight;       // headView distance to tableView's first cell
    float _spaceLength;
    float _tableWidth;
    float _cellHeight;
}

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) WVROrderSheetHeaderView *headView;

@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic, strong) NSMutableArray *goodsSelectArr;

@property (nonatomic, copy) void(^selectedBlock)(WVRPayPlatform tag, WVRPayGoodsType goodsType);
@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, strong) WVRPayModel *payModel;

/** [ @(WVRPayMethod) ] */
@property (nonatomic, strong) NSArray<NSNumber *> *payMethodList;

@end


@implementation WVROrderActionSheet

static NSString *const order_actionSheet_cellId = @"order_actionSheet_cellId";
static NSString *const order_actionSheet_footerId = @"order_actionSheet_footerId";

- (instancetype)initWithSuccessType:(WVRPayModel *)model cancelBlock:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        
        _type = OrderAlertTypeResultSuccess;
        _payModel = model;
        _cancelBlock = cancelBlock;
        
        [self buildData];
        [self createUI];
    }
    return self;
}

// payList: [ @(WVRPayMethod) ]
- (instancetype)initWithType:(OrderAlertType)type
                     payList:(NSArray<NSNumber *> *)payList
                   dataModel:(WVRPayModel *)model
               selectedBlock:(void(^)(WVRPayPlatform tag, WVRPayGoodsType goodsType))selectedBlock
                 cancelBlock:(void(^)(void))cancelBlock {
    self = [super init];
    if (self) {
        
        _type = type;
        _payMethodList = payList;
        _payModel = model;
        _selectedBlock = selectedBlock;
        _cancelBlock = cancelBlock;
        
        [self buildData];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.frame = [UIScreen mainScreen].bounds;
    
    [self backgroundView];
    
    [self tableView];
    
    [self addSubview:self.headView];
}

- (void)buildData {
    
    _footerHeight = adaptToWidth(8);
    _spaceLength = adaptToWidth(10);
    _cellHeight = adaptToWidth(57);
    _tableWidth = SCREEN_WIDTH - (_spaceLength * 2);
    
    NSMutableArray *arr = [NSMutableArray array];
    
    switch (_type) {
        case OrderAlertTypePayment: {
            for (NSNumber *method in self.payMethodList) {
                if (method.intValue == WVRPayMethodAlipay) {
                    
                    WVROrderAlertModel *aliModel = [[WVROrderAlertModel alloc] initWithTitle:@"支付宝" imgName:@"icon_alipay_pay" tag:WVRPayPlatformAlipay];
                    [arr addObject:aliModel];
                    
                } else if (method.intValue == WVRPayMethodWeixin) {
                    
                    WVROrderAlertModel *weChatModel = [[WVROrderAlertModel alloc] initWithTitle:@"微信支付" imgName:@"icon_weixin_pay" tag:WVRPayPlatformWeixin];
                    [arr addObject:weChatModel];
                    
                } else if (method.intValue == WVRPayMethodAppStore) {
                    
                    WVROrderAlertModel *appInModel = [[WVROrderAlertModel alloc] initWithTitle:@"购买" imgName:@"" tag:WVRPayPlatformAppIn];
                    [arr addObject:appInModel];
                } else if (method.intValue == WVRPayMethodWhaleyCurrency) {
                    
                    // 有鲸币支付的价格（购买鲸币时就不会有这个价格）并且用户的鲸币余额大于价格时，才展示鲸币购买选项
                    if (nil != _payModel.jingbiPrice && [WVRUserModel sharedInstance].wcBalance >= _payModel.jingbiPrice.integerValue) {

                        WVROrderAlertModel *appInModel = [[WVROrderAlertModel alloc] initWithTitle:@"鲸币支付" imgName:@"" tag:WVRPayPlatformWhaleyCurrency];
                        [arr addObject:appInModel];
                    }
                }
            }
        }
            break;
            
        case OrderAlertTypeResultSuccess: {
            
            WVROrderAlertModel *cancelModel = [[WVROrderAlertModel alloc] initWithTitle:@"关闭" imgName:@"" tag:0];
            [arr addObject:cancelModel];
        }
            break;
            
        case OrderAlertTypeResultFailed: {
            
            WVROrderAlertModel *retryModel = [[WVROrderAlertModel alloc] initWithTitle:@"重新支付" imgName:@"" tag:(NSInteger)_payModel.payPlatform];
            [arr addObject:retryModel];
        }
            break;
            
        default:
            break;
    }
    
    if (_type != OrderAlertTypeResultSuccess) {
        
        WVROrderAlertModel *cancelModel = [[WVROrderAlertModel alloc] initWithTitle:@"取消" imgName:@"" tag:0];
        [arr addObject:cancelModel];
    }
    
    _optionsArr = arr;
    
    float h = _optionsArr.count * (_cellHeight + _spaceLength);
    float tmpH = SCREEN_HEIGHT * 0.5f - h - self.headView.height * 0.5f;
    float gap = _spaceLength + adaptToWidth(10);
    _firstFooterHeight = tmpH > gap ? tmpH : gap;
}

#pragma mark - getter

/** 鲸币支付开关是否打开（展示不同的UI） */
- (BOOL)jingbiPayIsOpen {
    
    return [self havePayMethod:WVRPayMethodWhaleyCurrency];
}

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;
        maskView.userInteractionEnabled = YES;
        
        [self addSubview:maskView];
        _backgroundView = maskView;
    }
    return _backgroundView;
}

- (UITableView *)tableView {
        
    if (!_tableView) {
        float space = _spaceLength;
        
        CGRect rect = CGRectMake(space, SCREEN_HEIGHT, _tableWidth, _cellHeight * _optionsArr.count + _footerHeight * _optionsArr.count + self.headView.height + space);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = _cellHeight;
        tableView.bounces = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView = [[UIView alloc] init];
//        tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        [tableView registerClass:[WVROrderActionSheetCell class] forCellReuseIdentifier:order_actionSheet_cellId];
//        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:order_actionSheet_footerId];
        
        [self addSubview:tableView];
        _tableView = tableView;
        
        rect = CGRectMake(space, SCREEN_HEIGHT, _tableWidth, _optionsArr.count * (_cellHeight + _spaceLength));   //  + _firstFooterHeight + self.headView.height + space
        tableView.frame = rect;
        
        self.headView.bottomY = SCREEN_HEIGHT - _tableView.bounds.size.height - _firstFooterHeight + adaptToWidth(100);
    }
    
    return _tableView;
}

- (WVROrderSheetHeaderView *)headView {
    
    if (!_headView) {
        float x = (SCREEN_WIDTH - _tableWidth) / 2.f;
        if (_payModel.payComeFromType == WVRPayComeFromTypeWCurrency) {     // 购买鲸币
            
            _headView = [[WVROrderSWCurrencyHView alloc] initWithFrame:CGRectMake(x, 0, _tableWidth, 0) payModel:_payModel type:_type];
        } else {
            // 购买观看券
            _headView = [[WVROrderSheetHeaderView alloc] initWithFrame:CGRectMake(x, 0, _tableWidth, 0) payModel:_payModel type:_type canPayWithJingbi:[self jingbiPayIsOpen]];
        }
        _headView.alpha = 0;
    }
    
    return _headView;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WVROrderActionSheetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WVRPayPlatform payMethod = cell.orderTag;
    WVRPayGoodsType goodsType = self.headView.selectedType;
    NSInteger count = _optionsArr.count - 1;
    
    kWeakSelf(self);
    [self dismiss:^{
        
        if (indexPath.section < count) {
            if (weakself.selectedBlock) {
                weakself.selectedBlock(payMethod, goodsType);
            }
        } else {
            if (weakself.cancelBlock) {
                weakself.cancelBlock();
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _optionsArr.count;   //  + 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) { return 0; }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WVROrderActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:order_actionSheet_cellId];
    
    WVROrderAlertModel *model = [_optionsArr objectAtIndex:(indexPath.section)];    //  - 1
    
    [cell setTitle:model.title icon:model.image tag:model.orderTag];
    cell.layer.cornerRadius = adaptToWidth(13);
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    if (section == 0) { return _firstFooterHeight; }
    
    return _footerHeight;
}   

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
//    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:order_actionSheet_footerId];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

- (void)showWithAnimate {
    
    UIViewController *curVC = [UIViewController getCurrentVC_RootVC];
    
    [curVC.view addSubview:self];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.headView.alpha = 1;
                         _backgroundView.alpha = 0.55;
                         
                     } completion:^(BOOL finished) {
                         
                         [self secondAnimate];
                     }];
}

#define Animat_Time 0.25

// show 二级动画
- (void)secondAnimate {
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         CGRect rect = _tableView.frame;
                         rect.origin.y -= _tableView.bounds.size.height;
                         _tableView.frame = rect;
                         self.headView.bottomY = SCREEN_HEIGHT - _tableView.bounds.size.height - _firstFooterHeight;
                         
                     } completion:nil];
}

- (void)dismiss:(void(^)(void))completeBlock {
    
    [UIView animateWithDuration:Animat_Time
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect rect = _tableView.frame;
                         rect.origin.y += _tableView.bounds.size.height;
                         _tableView.frame = rect;
                         _backgroundView.alpha = 0;
                         self.headView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                         if (completeBlock) {
                             completeBlock();
                         }
                     }];
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    kWeakSelf(self);
//    [self dismiss:^{
//        
//        if (weakself.cancelBlock) {
//            weakself.cancelBlock();
//        }
//    }];
//}

- (BOOL)havePayMethod:(WVRPayMethod)payMethod {
    
    for (NSNumber *num in self.payMethodList) {
        if (num.integerValue == payMethod) {
            return YES;
        }
    }
    
    return NO;
}

@end


@implementation WVROrderAlertModel

- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName tag:(WVRPayPlatform)tag {
    self = [super init];
    if (self) {
        _orderTag = tag;
        _title = title;
        _imgName = imgName;
    }
    return self;
}

- (UIImage *)image {
    
    if (_imgName.length > 0) {
        return [UIImage imageNamed:_imgName];
    }
    return nil;
}

@end


@interface WVROrderActionSheetCell ()

@property (nonatomic, weak) UIButton *titleButton;

@end


@implementation WVROrderActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setUserInteractionEnabled:NO];
        
        [btn.titleLabel setFont:kFontFitForSize(17)];
        
        [self addSubview:btn];
        self.titleButton = btn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleButton.frame = self.bounds;
}

#pragma mark - external func

- (void)setTitle:(NSString *)title icon:(UIImage *)icon tag:(WVRPayPlatform)tag {
    
    _orderTag = tag;
    
    if (icon) {
        [self.titleButton setImage:icon forState:UIControlStateNormal];
        title = [@" " stringByAppendingString:title];
    }
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    if ([title isEqualToString:@"取消"]) {
        [self.titleButton setTitleColor:k_Color1 forState:UIControlStateNormal];
    } else {
        [self.titleButton setTitleColor:k_Color3 forState:UIControlStateNormal];
    }
}

@end
