//
//  WVRMyTicketListModel.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMyTicketListModel.h"
#import "WVRMyOrderItemModel.h"

@implementation WVRMyTicketListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"content" : [WVRMyTicketItemModel class], };
}

@end


@interface WVRMyTicketItemModel() {
    
    CGSize _sourceCodeSize;
    CouponSourceType _couponSource_type;
}

@end


@implementation WVRMyTicketItemModel
@synthesize priceStr = _priceStr;
@synthesize cellHeight = _cellHeight;
@synthesize nameLabelHeight = _nameLabelHeight;
@synthesize nameLabelWidth = _nameLabelWidth;

#pragma mark - YYModel

+ (NSArray *)modelPropertyBlacklist {
    
    return @[ @"priceStr", @"cellHeight", @"nameLabelHeight", @"nameLabelWidth" ];
}

#pragma mark - getter

- (PurchaseProgramType)purchaseType {
    
    return [WVRMyOrderItemModel purchaseTypeForGoodType:_relatedType];
}

- (CouponSourceType)couponSource_type {
    
    if (_couponSource_type == 0) {
        
        if ([_couponSource isEqualToString:@"order"]) {
            
            _couponSource_type = CouponSourceTypeOrder;
        } else if ([_couponSource isEqualToString:@"redeemCode"]) {
            
            _couponSource_type = CouponSourceTypeRedeemCode;
        } else {
            
            DDLogError(@"couponSource_type error， 未约定的类型");
            _couponSource_type = CouponSourceTypeOrder;
        }
    }
    
    return _couponSource_type;
}

- (NSString *)priceStr {
    
    if (!_priceStr) {
        _priceStr = [@"￥" stringByAppendingString:[WVRComputeTool numToPriceNumber:_price]];
    }
    return _priceStr;
}

- (CGSize)priceLabelSize {
    
    CGSize size = [WVRComputeTool sizeOfString:self.priceStr Size:CGSizeMake(800, 800) Font:[WVRMyTicketItemModel nameLabelFont]];
    
    return size;
}

- (float)cellHeight {
    
    if (!_displayName) { return 0; }
    
    if (_cellHeight <= 0) {
        float space = adaptToWidth(15);
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        float tmpWidth = width - 2 * space - 2 * space;
        float priceWidth = [self priceLabelSize].width;
        float nameWidth = tmpWidth - priceWidth - space;
        
        CGSize tmpSize = [WVRComputeTool sizeOfString:@"兑换码" Size:CGSizeMake(800, 800) Font:[WVRMyTicketItemModel nameLabelFont]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameWidth, 800)];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [WVRMyTicketItemModel nameLabelFont];
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.text = _displayName;
        [nameLabel sizeToFit];
        CGSize size = nameLabel.bounds.size;
        
        _nameLabelHeight = size.height;
        _nameLabelWidth = size.width;
        
        float sourceH = [self sourceCodeSize].height;
        if (sourceH > 0) {
            sourceH = sourceH + adaptToWidth(4);
        }
        
        _cellHeight = adaptToWidth(120) - tmpSize.height + size.height + sourceH;
    }
    
    return _cellHeight;
}

- (float)nameLabelWidth {
    
    if (!_displayName) { return 0; }
    
    if (_nameLabelWidth <= 0) {
        [self cellHeight];
    }
    
    return _nameLabelWidth;
}

- (float)nameLabelHeight {
    
    if (!_displayName) { return 0; }
    
    if (_nameLabelHeight <= 0) {
        [self cellHeight];
    }
    
    return _nameLabelHeight;
}

+ (UIFont *)nameLabelFont {
    
    return kBoldFontFitSize(15);
}

- (CGSize)sourceCodeSize {
    
    if ([self couponSource_type] != CouponSourceTypeRedeemCode) { return CGSizeZero; }
    
    if (_sourceCodeSize.height <= 0) {
        _sourceCodeSize = [WVRComputeTool sizeOfString:_couponSourceCode Size:CGSizeMake(800, 800) Font:kFontFitForSize(16)];
    }
    
    return _sourceCodeSize;
}

@end
