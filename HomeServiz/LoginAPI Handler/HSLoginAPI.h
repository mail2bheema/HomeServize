//
//  HSLoginAPI.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSWebAPI.h"
#import "HSLoginResponse.h"

@interface HSLoginAPI : HSWebAPI

+ (nonnull instancetype)loginApi;
- (void)getsignUpsuccessBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))successBlock inputDict:(NSDictionary *_Nullable)dict
                     failureBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))failureBlock;
- (void)getLoginsuccessBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))successBlock inputDict:(NSDictionary *_Nullable)dict
                 failureBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))failureBlock;


@end
