//
//  Bucket.h
//  BestTime
//
//  Created by iPhone8s on 2017/5/19.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBucketKeyTypeTag @"kBucketDataKeyTypeTag"
#define kBucketKeyTypeData @"kBucketDataKeyTypeData"

@interface Bucket : NSObject

- (instancetype)init;
- (void)bucketInWithKey: (NSString *)key value:(NSObject *)value;
- (NSObject *)bucketOutWithKey: (NSString *)key;
- (NSObject *)valueForkey:(NSString *)key;

@end
