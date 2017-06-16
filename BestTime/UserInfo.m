//
//  UserInfo.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/3.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UserInfo.h"
#import "ConversionHelper.h"

@implementation UserInfo

+ (instancetype)userInfoWithDictionary:(NSDictionary *)data {
    
    UserInfo *info = [[UserInfo alloc] init];
    
    if (data != nil) {
        
        // 数据调用 需要后端实现
        info.objectId = data[@"user"][@"objectId"];
        
        info.photo = data[@"photo"];
        
        info.nickname = data[@"nickname"];
        info.sex = data[@"sex"];
        info.record = data[@"record"];
        
        NSNumber *number = data[@"salary"];
        info.salaryValue = [number integerValue];
        info.salary = [ConversionHelper toStringWithNumber:number defaultValue:@""];
        
        number = data[@"age"];
        info.ageValue = [number integerValue];
        info.age = [ConversionHelper toStringWithNumber:number defaultValue:@""];
        
        number = data[@"height"];
        info.heightValue = [number integerValue];
        info.height = [ConversionHelper toStringWithNumber:number defaultValue:@""];
        
        info.marital = data[@"marital"];
        info.address = data[@"address"];
        info.contact = data[@"contact"];
        info.introduce = data[@"introduce"];
        
        info.createdAt = data[@"createdAt"];

        
        
    }
    
    return info;
}

@end
