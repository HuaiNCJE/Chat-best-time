//
//  VerifyHelper.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/27.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "VerifyHelper.h"

@implementation VerifyHelper

+ (BOOL)isEmptyString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if ([string isKindOfClass:NSNull.class]) {
        return YES;
    }
    
    // 截取前后空格
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *result = [string stringByTrimmingCharactersInSet:set];
    if (result.length == 0) {
        return YES;
    }
    
    return  NO;
}

@end
