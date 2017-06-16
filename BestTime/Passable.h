//
//  Passable.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/19.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Passable <NSObject>

@optional
// 所有传值需要实现的协议
- (void)viewControllerDidShowWithTag: (NSString *)tag data:(NSObject *)data;

@end
