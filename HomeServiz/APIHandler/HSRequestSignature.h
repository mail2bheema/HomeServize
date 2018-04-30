//
//  HSRequestSignature.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSRequest;
@class HSAPIResponse;

@interface HSRequestSignature : NSObject

+ (nonnull instancetype)requestSignatureWithRequest:(nonnull HSRequest *)request
                                       successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
                                       failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
                            validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock;

- (nonnull instancetype)initWithRequest:(nonnull HSRequest *)request
                           successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
                           failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
                validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock;

@property (strong, nonatomic, nullable, readonly) HSRequest *request;
@property (copy, nonatomic, nullable, readonly) void (^successBlock)(HSAPIResponse * _Nullable response);
@property (copy, nonatomic, nullable, readonly) void (^failureBlock)(HSAPIResponse * _Nullable response);
@property (copy, nonatomic, nullable, readonly) BOOL (^validateSuccessfulBlock)(HSAPIResponse * _Nullable response);

@end
