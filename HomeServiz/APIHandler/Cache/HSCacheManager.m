//
//  HSCacheManager.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSCacheManager.h"
#import "HSRequest.h"
#import "HSAPIResponse.h"
#import "NSString+Helper.h"
#import "NSDictionary+Validation.h"

static NSString *const kHSCacheName = @"hsCache";
static NSString *const kHSCachedData = @"hsCachedData";
static NSString *const kHSCacheLifeKey = @"hsCacheLife";
static NSString *const kHSCacheTimeStamp = @"hsTimestamp";

@interface HSCacheManager ()
//@property (strong, nonatomic) PINCache *pinCache;
@property (strong, nonatomic) dispatch_queue_t cacheQueue;
@end

@implementation HSCacheManager

static HSCacheManager *sharedInstance = nil;

+ (nonnull instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initializeCache];
    }
    return self;
}

- (void)initializeCache{
    _cacheQueue = dispatch_queue_create("com.hs.cache.queue", DISPATCH_QUEUE_CONCURRENT);
}

- (void)dataForRequest:(HSRequest *)request dataHandler:(void (^)(id data))datahandler{
    
    if (![[request uniqueKey] isNonEmpty]) {
        return ;
    }
    
//    __weak typeof(self) __weakSelf = self;
    
//    [[self pinCache] objectForKey:[self cacheKeyForRequest:request] block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object, NSDate * _Nullable dateModified) {
    
//        HSCacheManager *strongSelf = __weakSelf;
//        BOOL validData = [strongSelf validateData:(NSDictionary *)object forRequest:request forSavedDate:dateModified];
//
//        if (validData) {
//            datahandler ([(NSDictionary *)object objectForKey:kHSCachedData]);
//        }
//        else{
//            datahandler(nil);
//        }
//    }];
}

- (void)saveData:(id)data forRequest:(HSRequest *)request forResponse:(HSAPIResponse *)response{
    
    dispatch_barrier_sync(_cacheQueue, ^{
        BOOL shouldContinue = NO;
        if (![[request uniqueKey] isNonEmpty] || !data) {
            shouldContinue = NO;
        }
        else{
            shouldContinue = YES;
        }
        
        if (shouldContinue) {
            // Save for success responses only
            if (response.httpStatusCode == 200) {
                // Save Cache Information as Well
                NSMutableDictionary *cacheDict = [NSMutableDictionary new];
                [cacheDict setObject:data forKey:kHSCachedData];
                [cacheDict setObject:[NSNumber numberWithUnsignedInteger:request.cacheType] forKey:kHSCacheLifeKey];
                [cacheDict setObject:[NSDate date] forKey:kHSCacheTimeStamp];
                // Save it To The Cache
//                [[self pinCache] setObject:[NSDictionary dictionaryWithDictionary:cacheDict] forKey:[self cacheKeyForRequest:request]];
            }
            else{
                // Optimistically delete the cached data.
                [self removeDataForRequest:request];
            }
        }
    });
}

- (void)removeDataForRequest:(HSRequest *)request{
    dispatch_barrier_async(_cacheQueue, ^{
        if ([[request uniqueKey] isNonEmpty]) {
           // [[self pinCache] removeObjectForKey:[self cacheKeyForRequest:request]];
        }
    });
}

#pragma mark - Private

- (BOOL)validateData:(NSDictionary *)dictSaved forRequest:(HSRequest *)request forSavedDate:(NSDate *)savedDate{
    
    __block BOOL valid = NO;
    dispatch_sync(_cacheQueue, ^{
        NSDate *currentDate = [NSDate date];
        NSDate *savedDateLoc = [dictSaved objectForKey:kHSCacheTimeStamp];
        
        HSCacheType cacheType = [[dictSaved objectForKey:kHSCacheLifeKey] unsignedIntegerValue];
        NSUInteger cacheTime = [self cacheTimeWithCacheType:cacheType];
        
        if ([currentDate timeIntervalSinceDate:savedDateLoc] < cacheTime && !request.forceCacheRefresh) {
            valid = YES;
        }
        else{
            valid = NO;
        }
    });
    
    return valid;
}

- (NSUInteger)cacheTimeWithCacheType:(HSCacheType)cacheType{
    return [[[self cacheTypeMappingwithCacheTime] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)cacheType]] unsignedIntegerValue];
}

- (NSDictionary *)cacheTypeMappingwithCacheTime{
    return @{[NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheNone]: [NSNumber numberWithUnsignedInteger:0],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheDefault]: [NSNumber numberWithUnsignedInteger:60],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheThirtySeconds]: [NSNumber numberWithUnsignedInteger:30],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheOneMinute]: [NSNumber numberWithUnsignedInteger:60],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheTwoMinutes]: [NSNumber numberWithUnsignedInteger:120],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheFiveMinutes]: [NSNumber numberWithUnsignedInteger:300],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheTenMinutes]: [NSNumber numberWithUnsignedInteger:600],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheOneHour]: [NSNumber numberWithUnsignedInteger:3600],
             [NSString stringWithFormat:@"%lu", (unsigned long)kHSCacheADay]: [NSNumber numberWithUnsignedInteger:86400]};
}

- (NSString *)cacheKeyForRequest:(HSRequest *)request{
    NSString *cacheKey = [[[request uniqueKey] componentsSeparatedByString:kCacheDelimiter] firstObject];
    return cacheKey;
}

@end
