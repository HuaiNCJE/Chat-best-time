//
//  UINavigationController+Passable.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/20.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UINavigationController+Passable.h"
#import "Passable.h"
#import "Bucket.h"
#import "NavigationHelper.h"

@implementation UINavigationController (Passable)

// 根据ID入栈
- (void)pushViewControllerWithStoryboardID:(NSString *)identifier animated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self bucketInForController:vc tag:tag data:data];
    [self pushViewController:vc animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data {
    NSInteger count = self.viewControllers.count;
    if (count > 1) {
        // 拿出即将显示的controller
        UIViewController *controller = self.viewControllers[count - 2];
        [self bucketInForController:controller tag:tag data:data];
    }
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data {
    // 拿到根视图控制器
    UIViewController *vc = self.viewControllers[0];
    [self bucketInForController:vc tag:tag data:data];
    return [self popToRootViewControllerAnimated:animated];
}

- (void)pushViewControllerWithStoryboardID:(NSString *)identifier animated:(BOOL)animated data:(NSObject *)data {
    [self pushViewControllerWithStoryboardID:identifier animated:animated tag:nil data:data];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated data:(NSObject *)data {
    return [self popViewControllerAnimated:animated tag:nil data:data];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated data:(NSObject *)data {
    return [self popToRootViewControllerAnimated:animated tag:nil
                                             data:data];
}

#pragma mark - Private

- (void)bucketInForController:(UIViewController *)controller tag:(NSString *)tag data:(NSObject *)data {
    if ([controller conformsToProtocol:@protocol(Passable)]&& data !=nil) { NSString *key = [NSString stringWithFormat:@"%@", controller];
        
        NSMutableDictionary *entries = [@{kBucketKeyTypeData: data} mutableCopy];
        if (tag != nil) {
            entries[kBucketKeyTypeTag] = tag;
        }
        
        NavigationHelper *helper = [NavigationHelper defaultHelper];
        [helper.bucket bucketInWithKey:key value:entries];
    }
        
}
@end
