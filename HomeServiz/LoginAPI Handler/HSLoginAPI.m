//
//  HSLoginAPI.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSLoginAPI.h"
#import "HSJSonRequest.h"
#import "HSLoginResponse.h"

@implementation HSLoginAPI

static HSLoginAPI *sharedInstance = nil;

+ (nonnull instancetype)loginApi {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getsignUpsuccessBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))successBlock
inputDict:(NSDictionary *_Nullable)dict failureBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))failureBlock {
    
    NSMutableDictionary *headers = [NSMutableDictionary new];
    [headers addEntriesFromDictionary:[[self class] authorizationDictWithAccessToken:nil tokenType:nil]];

    HSJSonRequest *request = [[HSJSonRequest alloc] initRequestWithAPI:@"http://101.53.130.236:8282/api/register"                                withType:kHTTPRequestPOST withDictionaryBody:dict headers:headers];
    
    request.parserClass = [HSLoginResponse class];
    [self downloadDataForRequest:request successBlock:^(HSAPIResponse * _Nonnull response) {
        successBlock(((HSLoginResponse *)response));
    } failureBlock:^(HSAPIResponse * _Nonnull response) {
        failureBlock(((HSLoginResponse *)response));
    } validateSuccessfulBlock:nil];
}

- (void)getLoginsuccessBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))successBlock inputDict:(NSDictionary *_Nullable)dict
                failureBlock:(nonnull void (^)(HSLoginResponse * _Nonnull response))failureBlock {

    NSMutableDictionary *headers = [NSMutableDictionary new];
    [headers addEntriesFromDictionary:[[self class] authorizationDictWithAccessToken:nil tokenType:nil]];
    
    HSJSonRequest *request = [[HSJSonRequest alloc] initRequestWithAPI:@"http://101.53.130.236:8282/api/login"                                withType:kHTTPRequestPOST withDictionaryBody:dict headers:headers];
    
    request.parserClass = [HSLoginResponse class];
    [self downloadDataForRequest:request successBlock:^(HSAPIResponse * _Nonnull response) {
        successBlock(((HSLoginResponse *)response));
    } failureBlock:^(HSAPIResponse * _Nonnull response) {
        failureBlock(((HSLoginResponse *)response));
    } validateSuccessfulBlock:nil];

}
    
@end
