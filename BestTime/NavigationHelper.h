//
//  NavigationHelper.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/19.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bucket.h"

@interface NavigationHelper : NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) Bucket *bucket;

+ (instancetype)defaultHelper;
@end
