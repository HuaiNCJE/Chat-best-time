//
//  User.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/21.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *username;

+ (instancetype)currentUser;
+ (void)loginWithID:(NSString *)objectId username:(NSString *)username;
+ (void)logout;

@end
