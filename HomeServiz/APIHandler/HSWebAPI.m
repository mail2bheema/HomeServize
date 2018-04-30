//
//  HSAPI.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSWebAPI.h"
#import "HSWebApi+Helpers.h"
#import "HSAPIResponse.h"
#import "HSRequest.h"
#import "HSWebApi+Helpers.h"
#import "HSThreadSafeMap.h"
#import "HSWebAPIPrivateMembers.h"
#import "HSTask.h"
#import "HSRequestSignature.h"
#import "NSString+Helper.h"
#import "AFNetworking.h"



@class AFHTTPResponseSerializer;

static NSString *const kRequestHeader_Authorization = @"Authorization";

@interface HSWebAPI ()
@property (strong, nonatomic) AFHTTPResponseSerializer * _Nullable serializer;
@end



@implementation HSWebAPI

- (instancetype)init{
    if (self = [super init]) {
        //_cacheManager = [HSCacheManager manager];
        _networkRequests = [[HSThreadSafeMap alloc] init];
        _lock = [[NSLock alloc] init];
    }
    return self;
}
- (void)downloadDataForRequest:(nonnull HSRequest *)request
                  successBlock:(nonnull void (^)(HSAPIResponse * _Nonnull response))successBlock
                  failureBlock:(nonnull void (^)(HSAPIResponse * _Nonnull response))failureBlock
       validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nonnull response))validateSuccessfulBlock{
    
//    if (request.cacheType != kHSCacheNone) {
//        [[self cacheManager] dataForRequest:request dataHandler:^(id data) {
//            if (data) {
//                // It's a Valid Data, Convert the data into Model ,return the Model on Main Thread
//                HSAPIResponse *parsedResponse = [[self class] parseWithResponse:data
//                                                                        request:request
//                                                                    urlResponse:nil
//                                                                          error:nil];
//
//                NSLog(@"\n\n====== Cached API Response======\nRequest:%@\nHeaders:%@\nBody:%@\nResponse:%@\n======Cached API Response======\n\n",[request apiPath], [[request request] allHTTPHeaderFields], [[NSString alloc] initWithData:[[request request] HTTPBody] encoding:NSUTF8StringEncoding],data);
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    successBlock(parsedResponse);
//                });
//            }
//            else{
//                // Clear The Data
//                //[[self cacheManager] removeDataForRequest:request];
//
//                // Call Web Service to refresh the Data.
//                [self startSendingRequest:request
//                             successBlock:successBlock
//                             failureBlock:failureBlock
//                  validateSuccessfulBlock:validateSuccessfulBlock];
//            }
//        }];
//    }
//    else{
//        // Call Web Service to refresh the Data.
//        [self startSendingRequest:request
//                     successBlock:successBlock
//                     failureBlock:failureBlock
//          validateSuccessfulBlock:validateSuccessfulBlock];
//    }
    [self startSendingRequest:request
                 successBlock:successBlock
                 failureBlock:failureBlock
      validateSuccessfulBlock:validateSuccessfulBlock];

}

// Array of HSRequestSignature Objects
- (void)downloadDataForRequestSignatures:(nullable NSArray *)requestSignatures{
    for (int requestCount = 0; requestCount < [requestSignatures count]; requestCount++) {
        HSRequestSignature *requestSignature = [requestSignatures objectAtIndex:requestCount];
        
        if ([requestSignature isKindOfClass:[HSRequestSignature class]]) {
            [self downloadDataForRequest:[requestSignature request] successBlock:[requestSignature successBlock] failureBlock:[requestSignature failureBlock] validateSuccessfulBlock:[requestSignature validateSuccessfulBlock]];
        }
    }
}

- (void)startSendingRequest:(nonnull HSRequest *)request
               successBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))successBlock
               failureBlock:(nonnull void (^)(HSAPIResponse * _Nullable response))failureBlock
    validateSuccessfulBlock:(nullable BOOL (^)(HSAPIResponse * _Nullable response))validateSuccessfulBlock{
    
    // Increase retry count
    [request retryStarted];
    
    [self sendRequest:request withResponseBlock:^(HSRequest *request, HSAPIResponse *response, id responseData) {
        
        // Check if refresh Token Should be refreshed
//        [self shouldRefreshAccessTokenWithResponse:response requestSignature:[HSRequestSignature requestSignatureWithRequest:request successBlock:successBlock failureBlock:failureBlock validateSuccessfulBlock:validateSuccessfulBlock] refreshTokenBlock:^(BOOL refresh, BOOL success, NSArray * _Nullable continueWithRequests) {
//            if (refresh && success) {
//                // Restart the queued requests
//                [self downloadDataForRequestSignatures:continueWithRequests];
//            }
//            else if (!refresh && success){
//                BOOL isSuccess = NO;
//
//                if (validateSuccessfulBlock) {
//                    isSuccess = validateSuccessfulBlock(response);
//                }
//                else{
//                    isSuccess = [[self class] recognizeIfSuccessResponseWithResponse:response];
//                }
//
//                if (isSuccess) {
//                    // Cache Response, if neccessary and Successful
//                    if (request.cacheType != kHSCacheNone) {
//                        //[self cacheData:responseData response:response forRequest:request];
//                    }
//
//                    // Notify Through Block on Main Thread
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        successBlock(response);
//                    });
//                }
//                else{
//                    // Notify Through Block on Main Thread
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        failureBlock(response);
//                    });
//
//                    // Check If the Request should be retried.
//                    if (request.maxRetryCount > 0 && request.retries < request.maxRetryCount) {
//                        // Try Re-downloading the Response.
//                        [request retryStarted];
//                        [self startSendingRequest:request successBlock:successBlock failureBlock:failureBlock validateSuccessfulBlock:validateSuccessfulBlock];
//                    }
//                }
//            }
//            else{
//                // Fail All the Requests
//                for (HSRequestSignature *reqSignature in continueWithRequests) {
//                    reqSignature.request.shouldShowErrorMessage = NO;
//                    reqSignature.failureBlock(nil);
//                }
//
//                // Log the User out
//                // refresh token was unsuccessful
//
//            }
//       }];
        
    }];
}

- (void)sendRequest:(HSRequest *)request withResponseBlock:(ResponseBlock)responseBlock{
    
    if (![NSThread isMainThread]) {
        [_lock lock];
    }
    __block HSRequest *req = request;
    NSLog(@"--------------------------------current request running id - %@",request.uniqueKey);
    __weak typeof(self) __weakSelf = self;
    HSTask *networktask = [[HSTask alloc] initWithRequest:request delegate:self responseReceivedBlock:^(HSRequest *apiRequest, id responseData, NSError *error, NSURLResponse *response) {
        HSWebAPI *strongSelf = __weakSelf;
        
        // Serialise and Parse
        NSError *localError = nil;
        id responseObject;
        if (request.serializer) {
            responseObject = [req.serializer responseObjectForResponse:response data:responseData error:&localError];
        }else{
            responseObject = [[AFJSONResponseSerializer serializer] responseObjectForResponse:response data:responseData error:&localError];
        }
        HSAPIResponse *parsedResponse = [[self class] parseWithResponse:responseObject request:request urlResponse:response error:error];
        
#if APPSTORE == 0
        NSString *responseLogString = [NSString stringWithFormat:@"\n\n======API Response======\nRequest:%@\nHeaders:%@\nBody:%@\nHTTP Status Code:%ld\nResponse:%@\n======API Response======\nError:%@\n\n", [request apiPath], [(NSHTTPURLResponse *)response allHeaderFields], [[NSString alloc] initWithData:[[request request] HTTPBody] encoding:NSUTF8StringEncoding], (long)[(NSHTTPURLResponse *)response statusCode],responseObject, error];
        NSLog(@"%@", responseLogString);
        
       // [[HSDataLogger logger] logDateWiseWithText:responseLogString];
#endif
        
        // JWT Verification
        if (req.shouldVerifyJWT == YES) {
//            responseObject = [[self class] verifyJWTWithResponse:response withResponseRawJson:responseData andResponseDict:responseObject andParsedResponse:parsedResponse checkForDeviceBinding:NO];
        }
        
        [parsedResponse setShouldShowErrorMessage:[request shouldShowErrorMessage]];
        
        // Remove The Strong reference to the Request
        [[strongSelf networkRequests] deleteObjectForKey:[request uniqueKey]];
        
        // Notify with Response
        responseBlock(apiRequest, parsedResponse, responseObject);
    }];
    
    [[self networkRequests] addObject:networktask forKey:[request uniqueKey]];
    [networktask startNetworkTask];
    
    if (![NSThread isMainThread]) {
        [_lock unlock];
    }
}

#pragma mark - Public Helpers

+ (NSDictionary *)authorizationDictWithAccessToken:(NSString *)accessToken
                                         tokenType:(NSString *)tokenType{
    NSString *authorizationStr = [self accessTokenWithPassedAccessToken:accessToken tokenType:tokenType];
    if ([authorizationStr isNonEmpty]) {
        return [NSDictionary dictionaryWithObject:authorizationStr
                                           forKey:kRequestHeader_Authorization];
    }
    return [NSDictionary dictionary];
}

+ (NSDictionary *)versionHeaderWithVersion:(NSString *)version {
    return [NSDictionary dictionaryWithObject:version forKey:@"ver"];
}

+ (NSString *)accessTokenWithPassedAccessToken:(NSString *)accessToken
                                     tokenType:(NSString *)tokenType{
    if ([accessToken isNonEmpty] && [tokenType isNonEmpty]) {
        return [NSString stringWithFormat:@"%@ %@", tokenType, accessToken];
    }
    
//    if ([[[HSAccessTokenManager manager] token_type] isNonEmpty] && [[[HSAccessTokenManager manager] accessToken] isNonEmpty]) {
//        return [NSString stringWithFormat:@"%@ %@", [[HSAccessTokenManager manager] token_type], [[HSAccessTokenManager manager] accessToken]];
//    }
    return nil;
}

- (void)cancelRequest:(nonnull HSRequest *)request{
    HSTask *task = [[self networkRequests] getObjectForKey:[request uniqueKey]];
    if (task) {
        [task stopNetworkTask];
    }
}

- (void)cancelAllRequests{
    NSArray *allTaskKeys = [[self networkRequests] getAllKeys];
    
    for (NSString *key in allTaskKeys) {
        HSTask *task = [[self networkRequests] getObjectForKey:key];
        if (task) {
            [task stopNetworkTask];
        }
    }
}

@end
