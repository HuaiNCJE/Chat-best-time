//
//  UIColor+Int.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/27.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UIColor+Int.h"

@implementation UIColor (Int)

+ (UIColor *)colorWithComponent:(NSInteger)component alpha:(NSInteger)alpha {
    CGFloat w = component / 255.0;
    CGFloat a = alpha / 255.0;
    return [UIColor colorWithWhite:w alpha:a];
}

+ (UIColor *)colorWithComponent:(NSInteger)component{
    return [self colorWithComponent:component alpha:255];
}

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(NSInteger)alpha {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    CGFloat a = alpha / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b {
    return [self colorWithR:r G:g B:b A:255];
}

+ (UIColor *)colorWithHex:(NSInteger)hex {
    NSInteger r = (hex & 0xFF0000) >> 16;
    NSInteger g = (hex &  0xFF00) >> 8;
    NSInteger b = hex & 0xFF;
    return [UIColor colorWithR:r G:g B:b];
    
}

@end
