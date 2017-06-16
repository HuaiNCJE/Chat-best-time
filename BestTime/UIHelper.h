//
//  UIHelper.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/27.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface UIHelper : NSObject

// 提示信息的展示
+ (void)showLoadingInView:(UIView *)view hasText:(BOOL)hasText;
+ (void)showLoadingInView:(UIView *)view;
+ (void)dismissLoadingInView:(UIView *)view;
+ (void)showTipsWithText:(NSString *)text inView:(UIView *)view;
+ (void)showErrorWithText:(NSString *)text inView:(UIView *)view;
@end
