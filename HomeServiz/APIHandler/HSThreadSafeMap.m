//
//  HSThreadSafeMap.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSThreadSafeMap.h"

@interface HSThreadSafeMap ()
@property (strong, nonatomic) NSMutableDictionary *cache;
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation HSThreadSafeMap

- (instancetype)init{
    if (self = [super init]) {
        _cache = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.HomeServiz.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)addObject:(nonnull id)obj forKey:(nonnull NSString *)key{
    dispatch_barrier_async(self.queue, ^{
        [self.cache setObject:obj forKey:key];
    });
}

- (nonnull id)getObjectForKey:(nonnull NSString *)key{
    __block id fetchedObj = nil;
    dispatch_barrier_sync(self.queue, ^{
        fetchedObj = [self.cache objectForKey:key];
    });
    return fetchedObj;
}

- (nullable NSArray *)getAllKeys{
    __block NSArray *allKeys = nil;
    dispatch_barrier_async(self.queue, ^{
        allKeys = [self.cache allKeys];
    });
    return allKeys;
}

- (void)deleteObjectForKey:(nonnull NSString *)key{
    dispatch_barrier_async(self.queue, ^{
        [self.cache removeObjectForKey:key];
    });
}

- (void)deleteAllObjects{
    dispatch_barrier_async(self.queue, ^{
        [self.cache removeAllObjects];
    });
}

- (void)dealloc{
    _cache = nil;
    _queue = nil;
}

@end
