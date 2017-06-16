//
//  HomeViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/17.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+Base.h"
#import <SDCycleScrollView.h>
#import <SDAutoLayout.h>


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.slideMenuController.pan.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.slideMenuController.pan.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置委托
    NavigationHelper *helper = [NavigationHelper defaultHelper];
    self.navigationController.delegate = helper;
    
}



//- (IBAction)testButtonPressed:(id)sender {
//    [self.slideMenuController switchController];
//    
//}
@end
