//
//  UserInfo.h
//  BestTime
//
//  Created by iPhone8s on 2017/6/3.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户的详细信息
@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *record;

@property (nonatomic, strong) NSString *salary;
@property (nonatomic, assign) NSInteger salaryValue;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, assign) NSInteger ageValue;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, assign) NSInteger heightValue;

@property (nonatomic, strong) NSString *marital;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *introduce;

@property (nonatomic, strong) NSString *createdAt;

+ (instancetype)userInfoWithDictionary:(NSDictionary *)data;

@end
