//
//  UIViewController+Base.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/18.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UIViewController+Base.h"
#import "UserViewController.h"
#import "SlideMenuController.h"

@implementation UIViewController (Base)

// 抽屉效果的实现
- (SlideMenuController *)slideMenuController {
    UIViewController *controller = self.parentViewController;
    
    while (controller != nil) {
        if (controller.class == SlideMenuController.class) {
            return (SlideMenuController *)controller;
        } else {
            controller = controller.parentViewController;
        }
    }
    
    return nil;
}

// 返回至主页面
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 返回至个人页面
//- (IBAction)backPersonPressed:(id)sender {
//    UserViewController *user = [[UserViewController alloc] init];
//    
//    // 用导航栏推送 进行视图切换
//    [self.navigationController pushViewController:user animated:YES];
//}

//- (IBAction)backSlideMenuController:(id)sender {
//    SlideMenuController *menu = [[SlideMenuController alloc] init];
//    
//    // 用导航栏推送 进行视图切换
//    [self.navigationController pushViewController:menu animated:YES];
//}


- (IBAction)backSlideMenuPressed:(id)sender {
    [self.slideMenuController switchController];
    
}




@end
