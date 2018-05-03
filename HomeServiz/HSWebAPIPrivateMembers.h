
//
//  HSWebAPIPrivateMembers.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSWebAPI.h"
#import "HSNetworkProtocols.h"


@class HSThreadSafeMap;
@class HSCacheManager;

@interface HSWebAPI () <HSAPIDelegate>
@property (nullable, strong, nonatomic) HSCacheManager *cacheManager;
@property (nullable, strong, nonatomic) HSThreadSafeMap *networkRequests;

@property (nonnull, strong, nonatomic) NSLock *lock;

- (void)startSendingRequest:(nonnull HSRequest *)request
               successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
               failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
    validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock;

@end
