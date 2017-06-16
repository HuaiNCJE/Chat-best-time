//
//  UINavigationController+Passable.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/20.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Passable)

- (void)pushViewControllerWithStoryboardID:(NSString *)identifier animated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data;

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated tag:(NSString *)tag data:(NSObject *)data;

- (void)pushViewControllerWithStoryboardID:(NSString *)identifier animated:(BOOL)animated  data:(NSObject *)data;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated  data:(NSObject *)data;

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated  data:(NSObject *)data;
@end
