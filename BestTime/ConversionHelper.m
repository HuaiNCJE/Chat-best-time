//
//  ConversionHelper.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/5.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

// 
#import "ConversionHelper.h"
#import "VerifyHelper.h"
#import "UtilsMacro.h"

@implementation ConversionHelper

// Number转换为字符串
+ (NSString *)toStringWithNumber:(NSNumber *)number defaultValue:(NSString *)value {
    if (number != nil && [number intValue] > 0) {
        return [NSString stringWithFormat:@"%d",[number intValue]];
    } else {
        return value;
    }
}

// 字符串转换为自己想要的形式
+ (NSString *)stringWithString:(NSString *)string defaultValue:(NSString *)value {
    // 不为空字符串
    if (![VerifyHelper isEmptyString:string]) {
        return string;
    } else {
        return value;
    }
}

+ (NSDictionary *)timeIntervalFromDateString:(NSString *)string {
    
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 指定格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 进行格式化日期转化
    NSDate *date = [formatter dateFromString:string];
    
    // 获取日历标签
    NSCalendarUnit flags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute);
    // 生成日历对象
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    // 获取过去时间
    NSDateComponents *componentsPast = [calendar components:flags fromDate:date];
    // 获取当前时间
    NSDateComponents *componentsNow = [calendar components:flags fromDate:[NSDate date]];
    
    // 获得过去月有多少天
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    // 天数
    NSInteger daysInLastMonth = range.length;
    NSInteger years = componentsNow.year - componentsPast.year;
    NSInteger months =  componentsNow.month - componentsPast.month + years * 12;
    NSInteger days = componentsNow.day - componentsPast.day + months * daysInLastMonth;
    NSInteger hours = componentsNow.hour - componentsPast.hour + days * 24;
    NSInteger minutes = componentsNow.minute - componentsPast.minute + hours * 60;
    
    // 构造数组进行传值
    NSDictionary *result = @{kDateTypeYears: [NSNumber numberWithInteger:years],
                             kDateTypeMonths:[NSNumber numberWithInteger:months],
                             kDateTypeDays: [NSNumber numberWithInteger:days],
                             kDateTypeHours:[NSNumber numberWithInteger:hours],
                             kDateTypeMinutes:[NSNumber numberWithInteger:minutes],
                             };
    return result;
}

// 从当前时间到此刻时间
+ (NSString *)intervalSinceNowFromDateString:(NSString *)string {
    // 调用函数 取值
    NSDictionary *data = [self timeIntervalFromDateString:string];
    NSInteger months = [data[kDateTypeMonths] integerValue];
    NSInteger days = [data[kDateTypeDays] integerValue];
    NSInteger hours = [data[kDateTypeHours] integerValue];
    NSInteger minutes = [data[kDateTypeMinutes] integerValue];
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    } else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", hours];
    } else if (hours < 48 && days == 1) {
        return @"昨天";
    } else if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    } else if (days < 60) {
        return @"一个月前";
    } else if (months < 12) {
        return [NSString stringWithFormat:@"%ld个月前",months];
    } else {
        // 拆分字符串 拿出年月日
        NSArray *components = [string componentsSeparatedByString:@""];
        return components.firstObject;
    }
}

@end
