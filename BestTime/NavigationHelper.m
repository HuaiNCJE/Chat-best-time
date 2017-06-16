//
//  NavigationHelper.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/19.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "NavigationHelper.h"
#import "Passable.h"

// 单例 局部可见 保持不透明
static NavigationHelper *_instance = nil;

@implementation NavigationHelper

// 调用方法时 实例唯一
+ (instancetype)defaultHelper {
    static dispatch_once_t token;
    
    // GCD 代码块执行唯一一次 保证线程安全
    dispatch_once(&token, ^{
        _instance = [[super allocWithZone:NULL] init];
        [_instance initialization];
    });
    
    return  _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [NavigationHelper defaultHelper];
}

// 对同一个对象的引用
- (id)copyWithZone:(struct _NSZone *)zone {
    return [NavigationHelper defaultHelper];
}

#pragma mark - UINavigationcontrollerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController conformsToProtocol:@protocol(Passable)]) {
        id<Passable> object = (id<Passable>)viewController;
        if ([object respondsToSelector:@selector(viewControllerDidShowWithTag:data:)]) {
            NSString *key = [NSString stringWithFormat:@"%@", viewController];
            NSDictionary *entries = (NSDictionary *)[_bucket bucketOutWithKey:key];
            if (entries != nil) {
                NSString *tag = entries[kBucketKeyTypeTag];
                NSObject *data = entries[kBucketKeyTypeData];
                [object viewControllerDidShowWithTag:tag data:data ];
            }
        }
    }
}

#pragma mark - Private

- (void)initialization {
    self.bucket = [[Bucket alloc] init];
}


@end
