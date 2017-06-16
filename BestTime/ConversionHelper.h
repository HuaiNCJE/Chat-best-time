//
//  ConversionHelper.h
//  BestTime
//
//  Created by iPhone8s on 2017/6/5.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>

// 类型转换
@interface ConversionHelper : NSObject

// 数值转换
+ (NSString *)toStringWithNumber:(NSNumber *)number defaultValue:(NSString *)value;

// 安全化字符串
+ (NSString *)stringWithString:(NSString *)string defaultValue:(NSString *)value;

// 距离当前时间的间隔
+ (NSDictionary *)timeIntervalFromDateString:(NSString *)string;

// 过去的时间距离现在的称呼
+ (NSString *)intervalSinceNowFromDateString:(NSString *)string;

@end
