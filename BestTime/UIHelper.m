//
//  UIHelper.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/27.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UIHelper.h"
#import "UIColor+Int.h"

@implementation UIHelper

+ (void)showLoadingInView:(UIView *)view hasText:(BOOL)hasText {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView *container = (view != nil ? view : window);
    // 设置提示框   显示转动的风火轮
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
    hud.bezelView.color = [UIColor colorWithHex:0xd78b93];
    if (hasText) {
        hud.label.text = @"加载中";
    }
}

+ (void)showLoadingInView:(UIView *)view {
    [self showLoadingInView:view hasText:NO];
}

+ (void)dismissLoadingInView:(UIView *)view {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView *container = (view != nil ? view : window);
    [MBProgressHUD hideHUDForView:container animated:YES];
}

// 显示提示文字
+ (void)showTipsWithText:(NSString *)text inView:(UIView *)view {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView *container = (view != nil ? view : window);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
    
    // 指定颜色
    hud.bezelView.color = [UIColor colorWithHex:0xd78b93];
    // 指定自定义内容视图
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    hud.detailsLabel.text = text;
    
    // 1.5秒 自动隐藏
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showErrorWithText:(NSString *)text inView:(UIView *)view {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    UIView *container = (view != nil ? view : window);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
    
    hud.bezelView.color = [UIColor colorWithHex:0xd78b93];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    hud.detailsLabel.text = text;
 
    [hud hideAnimated:YES afterDelay:1.5];

}

@end
