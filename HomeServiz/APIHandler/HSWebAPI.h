//
//  HSAPI.h
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSRequest.h"
#import "HSAPIResponse.h"


@interface HSWebAPI : NSObject

- (void)downloadDataForRequest:(nonnull HSRequest *)request
                  successBlock:(nonnull void (^)(HSAPIResponse * _Nonnull response))successBlock
                  failureBlock:(nonnull void (^)(HSAPIResponse * _Nonnull response))failureBlock
       validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nonnull response))validateSuccessfulBlock;

- (void)cancelRequest:(nonnull HSRequest *)request;
- (void)cancelAllRequests;

// Array of HSRequestSignature Objects
- (void)downloadDataForRequestSignatures:(nullable NSArray *)requestSignatures;

//- (BOOL)recognizeIfSuccessResponseWithResponse:(nonnull HSAPIResponse *)response;

+ (nonnull NSDictionary *)authorizationDictWithAccessToken:(nullable NSString *)accessToken
                                                 tokenType:(nullable NSString *)tokenType;
//+ (nonnull NSString *)accessTokenWithPassedAccessToken:(nullable NSString *)accessToken
//                                             tokenType:(nullable NSString *)tokenType;

+ (nonnull NSDictionary *)versionHeaderWithVersion:(nonnull NSString *)version;

@end
