//
//  UIColor+Int.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/27.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Int)

+ (UIColor *)colorWithComponent:(NSInteger)component alpha:(NSInteger)alpha;
+ (UIColor *)colorWithComponent:(NSInteger)component;

+ (UIColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(NSInteger)a;
+ (UIColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;

// 十六进制的颜色值
+ (UIColor *)colorWithHex:(NSInteger)hex;
@end
