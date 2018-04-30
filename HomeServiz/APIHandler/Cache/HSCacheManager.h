//
//  JMCacheManager.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCacheManagerPrivate.h"

@class HSRequest;
@class HSAPIResponse;

@interface HSCacheManager : NSObject

+ (instancetype)manager;

- (void)dataForRequest:(HSRequest *)request dataHandler:(void (^)(id data))datahandler;
- (void)saveData:(id)data forRequest:(HSRequest *)request forResponse:(HSAPIResponse *)response;
- (void)removeDataForRequest:(HSRequest *)request;

@end
