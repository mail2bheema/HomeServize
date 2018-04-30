//
//  HSRequestSignature.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSRequestSignature.h"
#import "HSAPIResponse.h"


@implementation HSRequestSignature

- (nonnull instancetype)initWithRequest:(nonnull HSRequest *)request
                           successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
                           failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
                validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock{
    if (self = [super init]) {
        _request = request;
        _successBlock = successBlock;
        _failureBlock = failureBlock;
        _validateSuccessfulBlock = validateSuccessfulBlock;
    }
    return self;
}

+ (nonnull instancetype)requestSignatureWithRequest:(nonnull HSRequest *)request
                                       successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
                                       failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
                            validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock{
    return [[self alloc] initWithRequest:request successBlock:successBlock failureBlock:failureBlock validateSuccessfulBlock:validateSuccessfulBlock];
}

@end
