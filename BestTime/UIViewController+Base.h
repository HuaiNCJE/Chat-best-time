//
//  UIViewController+Base.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/18.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuController.h"
#import "Passable.h"
#import "NavigationHelper.h"
#import "UINavigationController+Passable.h"

@interface UIViewController (Base)

@property (nonatomic, readonly) SlideMenuController *slideMenuController;

@end
