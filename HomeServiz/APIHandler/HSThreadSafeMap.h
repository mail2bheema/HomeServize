//
//  HSThreadSafeMap.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSThreadSafeMap : NSObject
- (void)addObject:(nonnull id)obj forKey:(nonnull NSString *)key;
- (nonnull id)getObjectForKey:(nonnull NSString *)key;
- (nullable NSArray *)getAllKeys;
- (void)deleteObjectForKey:(nonnull NSString *)key;
- (void)deleteAllObjects;

@end
