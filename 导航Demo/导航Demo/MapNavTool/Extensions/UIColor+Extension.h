//
//  UIColor+Extension.h
//  YYFocus
//
//  Created by anjun on 15/7/7.
//  Copyright (c) 2015年 anjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  根据颜色字符串得到颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor*)colorWithKey:(NSUInteger)key;

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;

@end
