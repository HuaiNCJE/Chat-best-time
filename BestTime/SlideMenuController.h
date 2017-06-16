//
//  SlideMenuController.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/17.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuController : UIViewController

@property (nonatomic, weak) IBOutlet UIPanGestureRecognizer *pan;

- (void)switchController;

@end
