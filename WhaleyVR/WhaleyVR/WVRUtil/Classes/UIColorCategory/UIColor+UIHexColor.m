//
//  UIColor+UIHexColor.m
//  WhaleyVR
//
//  Created by qbshen on 2017/5/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "UIColor+UIHexColor.h"

@implementation UIColor (UIHexColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    
    UIColor * nameForColor = [UIColor colorNameToUIColor:cString];
    if(nameForColor!=nil)
    {
        return nameForColor;
    }
    
    // 字符串必须最小6个字符
    if ([cString length] < 3) return [UIColor clearColor];
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if (![UIColor valideColorStrFormat:cString])
    {
        
        return [UIColor clearColor];
    }
    
    if ([cString length] == 3)
    {
        NSArray * colorSplits = [cString componentsSeparatedByString:@""];
        if(colorSplits.count==3)
        {
            cString = @"";
            for (NSString * item in colorSplits) {
                cString  = [cString stringByAppendingFormat:@"%@%@",item,item];
            }
        }
    }
    if ([cString length] == 6)
    {// Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
    else if ([cString length] == 8)
    {
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *aString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int a, r, g, b;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:((float) a / 255.0f)];
    }
    else {
        return [UIColor clearColor];
    }
}

/**
 *
 * 通过颜色名称读取Color
 */
+ (UIColor *)colorNameToUIColor:(NSString *)name
{
    if (name==nil || name.length==0)
    {
        return nil;
    }
    
    name = [name lowercaseString];
    
    NSDictionary * COLOR_DICT = @{  @"transparent" : [UIColor colorWithRed:0 green:0 blue:0 alpha:0],
                                    @"black" : [UIColor blackColor],
                                    @"white" : [UIColor whiteColor],
                                    @"gray" : [UIColor grayColor],
                                    @"green" : [UIColor greenColor],
                                    @"blue" : [UIColor blueColor],
                                    @"cyan" : [UIColor cyanColor],
                                    @"yellow" : [UIColor yellowColor],
                                    @"magenta" : [UIColor magentaColor],
                                    @"orange" : [UIColor orangeColor],
                                    @"purple" : [UIColor purpleColor],
                                    @"brown" : [UIColor brownColor]
                                    };
    
    return COLOR_DICT[name];
}

/**
 ** 颜色值校验
 **/
+ (BOOL)valideColorStrFormat:(NSString *) source
{
    
    if (source == nil || source.length == 0) {
        
        return NO;
    }
    
    if (source.length != 3 && source.length != 6 && source.length != 8) {
        
        return NO;
    }
    
    NSError * error;
    NSString * strNumberRegExp = @"^(([\\da-fA-F]{3}){1,2}|([\\da-fA-F]{8}))$";
    NSRegularExpression * regExp = [NSRegularExpression regularExpressionWithPattern:strNumberRegExp options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:&error];
    NSArray * matchResults  = [regExp matchesInString:source options:NSMatchingReportCompletion range:NSMakeRange(0, source.length)];
    
    if (matchResults != nil && matchResults.count == 1) {
        
        NSRange range = [matchResults[0] range];
        return [source isEqualToString:[source substringWithRange:range]];
    }
    
    return NO;
}

//颜色转字符串
+ (NSString *)changeUIColorToRGB:(UIColor *)color {
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    
    NSString *r = [NSString stringWithFormat:@"%@", [self  ToHex:cs[0] * 255]];
    NSString *g = [NSString stringWithFormat:@"%@", [self  ToHex:cs[1] * 255]];
    NSString *b = [NSString stringWithFormat:@"%@", [self  ToHex:cs[2] * 255]];
    
    return [NSString stringWithFormat:@"#%@%@%@", r, g, b];
}


//十进制转十六进制
+ (NSString *)ToHex:(int)tmpid {
    
    NSString *endtmp= @"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig = tmpid % 16;
    int tmp = tmpid / 16;
    
    switch (ttmpig) {
            
        case 10:
            nLetterValue = @"A"; break;
        case 11:
            nLetterValue = @"B"; break;
        case 12:
            nLetterValue = @"C"; break;
        case 13:
            nLetterValue = @"D"; break;
        case 14:
            nLetterValue = @"E"; break;
        case 15:
            nLetterValue = @"F"; break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i", ttmpig];
    }
    
    switch (tmp) {
            
        case 10:
            nStrat = @"A"; break;
        case 11:
            nStrat = @"B"; break;
        case 12:
            nStrat = @"C"; break;
        case 13:
            nStrat = @"D"; break;
        case 14:
            nStrat = @"E"; break;
        case 15:
            nStrat = @"F"; break;
        default:
            nStrat = [[NSString alloc]initWithFormat:@"%i", tmp];
    }
            
    endtmp = [[NSString alloc]initWithFormat:@"%@%@", nStrat, nLetterValue];
    
    return endtmp;
}

@end
