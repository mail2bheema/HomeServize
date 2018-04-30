//
//  HSTask.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSTask.h"
#import "HSWebApi+Helpers.h"
#import "AFNetworking.h"
#import "HSAPIResponse.h"
#import "NSString+Helper.h"
//#import "HSKeychain.h"
#import "NSData+Helper.h"
#import "NSData+CommonCrypto.h"
//#import "HSDataLogger.h"
#import "NSString+AES.h"
#import "NSData+AES.h"

NSString *HSResponseHeaderkey = @"encrypted-data";
NSString *HSHashKey = @"3d49b7dcaf80bdfa0a8d782ee91b6947";


@import Security;

@interface HSTask ()
@property (weak, nonatomic) id <HSAPIDelegate> delegate;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (assign, nonatomic) __block BOOL inSecure;
@end

@implementation HSTask

- (instancetype)initWithRequest:(HSRequest *)request delegate:(id <HSAPIDelegate>)delegate responseReceivedBlock:(TaskBlock)responseReceivedBlock{
    if (self = [super init]) {
        [self initiateRequest:request withResponseBlock:responseReceivedBlock];
    }
    return self;
}

- (void)initiateRequest:(HSRequest *)request withResponseBlock:(TaskBlock)responseBlock{
    
    AFHTTPSessionManager *afManager = [AFHTTPSessionManager manager];
    if (request.serializer) {
        [afManager setResponseSerializer:[request serializer]];
    }
    
    // Always Set Response Serializer as Data
    [afManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
#if ENABLE_SSL_PINNING_GLOBALLY
    AFSecurityPolicy *securitypolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securitypolicy setAllowInvalidCertificates:YES];
    [afManager setSecurityPolicy:securitypolicy];
#endif
    
#if APPSTORE == 0
    NSString *requestLogString = [NSString stringWithFormat:@"\n\n======Sending API Request======\nRequest:%@\nHeaders:%@\nBody:%@\n********Sending API Request********\n\n", [request apiPath], [[request request] allHTTPHeaderFields], [[NSString alloc] initWithData:[[request request] HTTPBody] encoding:NSUTF8StringEncoding]];
    NSLog(@"%@", requestLogString);
    
    //[[HSDataLogger logger] logDateWiseWithText:requestLogString];
#endif
    
    _inSecure = NO;
    _dataTask = [afManager dataTaskWithRequest:[request request] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
            NSString *plainString = headers[HSResponseHeaderkey];
            
            if (plainString) {
                
                NSData *keyData = [HSHashKey dataFromHexString];
                NSData *dataToDecrypt = [[NSData alloc] initWithBase64EncodedString:plainString options:0];
                NSData *decryptedData = [dataToDecrypt AES128DecryptedDataWithKey:keyData];
                NSString *serverReturnedChecksum = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                
                NSString *clientGeneratedChecksum = [[(NSData *)responseObject SHA256Hash] hexString];
                
                if ([serverReturnedChecksum isEqualToString:clientGeneratedChecksum] == NO) {
                    
                    NSString *errorStr = NSLocalizedStringWithDefaultValue(@"Response Checksum Mismatch Error", nil, [NSBundle mainBundle], @"Error while processing request. Please try again later.", @"Chechsum send from server and client generated checksum didn't match message");
                    
                    NSDictionary *errorRes = @{@"code":[NSString stringWithFormat:@"%ld",(long)HSResultResponseChecksumMismatch],
                                               @"message" : errorStr,
                                               @"reason" : @"checksum mismatched",
                                               @"desc" : @"it is client generated response"
                                               };
                    
                    responseObject = [NSJSONSerialization dataWithJSONObject:errorRes options:NSJSONWritingPrettyPrinted error:nil];
                }
            }
        }
        
        NSError *errorLoc = nil;
        if (_inSecure) {
            NSMutableDictionary *errorDict = nil;
            if ([error userInfo]) {
                errorDict = [[NSMutableDictionary alloc] initWithDictionary:[error userInfo]];
            }else{
                errorDict = [NSMutableDictionary new];
            }
            
            [errorDict setObject:@"insecure" forKey:@"isInSecure"];
            errorLoc = [[NSError alloc] initWithDomain:[error domain] code:[error code] userInfo:errorDict];
        }
        else {
            errorLoc = error;
        }
        
        responseBlock(request, responseObject, errorLoc, response);
    }];
    
    [self handleAuthenticationChallengeWithAFManager:afManager];
    [self handleRedirectionWithAFManager:afManager];
    [self disableIOSLevelCachingWithAFManager:afManager];
}

#pragma mark - Start/Stop

- (void)startNetworkTask{
    [_dataTask resume];
}

- (void)stopNetworkTask{
    if ([_dataTask state] == NSURLSessionTaskStateRunning) {
        [_dataTask cancel];
    }
}

#pragma mark - NSURLSessionDataTask Blocks

- (void)handleAuthenticationChallengeWithAFManager:(AFHTTPSessionManager *)afManager{
    
#if ENABLE_SSL_PINNING_GLOBALLY
    __weak typeof(self) __weakSelf = self;
    [afManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        NSURLSessionAuthChallengeDisposition disposition = [__weakSelf challengeDispositionForChallenge:challenge];
        if (disposition == NSURLSessionAuthChallengeCancelAuthenticationChallenge) {
            _inSecure = YES;
        }
        return disposition;
    }];
#endif
}

- (void)handleRedirectionWithAFManager:(AFHTTPSessionManager *)afManager{
    [afManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        return request;
    }];
}

- (void)disableIOSLevelCachingWithAFManager:(AFHTTPSessionManager *)afManager{
    
    // App level Caching Implemented, so disable the default caching mechanism.
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    urlCache = nil;
    
    [afManager setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
        return nil;
    }];
}

@end
