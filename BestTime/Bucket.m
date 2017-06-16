//
//  Bucket.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/19.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "Bucket.h"

@interface Bucket ()

@property (nonatomic, strong) NSMutableDictionary *data;
@end

@implementation Bucket

// 调用父类方法 创建可变字典
- (instancetype)init {
    if (self = [super init]) {
        self.data = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

// 向字典里插入值
- (void)bucketInWithKey:(NSString *)key value:(NSObject *)value {
    _data[key] = value;
}

// 移除字典里的值
- (NSObject *)bucketOutWithKey:(NSString *)key {
    NSObject *value = _data[key];
    [_data removeObjectForKey:key];
    return value;
}

// 查询返回结果值
- (NSObject *)valueForkey:(NSString *)key {
    return _data[key];
}

@end
