//
//  HSRequest.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSRequest.h"
#import "NSDictionary+Validation.h"
#import "NSString+Helper.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kIgnoreCharectersInCacheKey = @"[&'*,.=~?/:;]";
static NSString *const kCacheDelimiter = @"CacheDelimiter-Hs";
static NSString *const kRequestHeader_API_Key = @"X-API-KEY";
static NSString *const kRequestHeader_ContentType = @"Content-Type";
static NSString *const kRequestHeader_X_Forwarded_Host_API_Key = @"X-Forwarded-Host";

@interface HSRequest ()
@property (nonatomic, strong, readwrite) NSString *uniqueKey;
@property (nonatomic, strong, readwrite) NSDictionary *headers;
@property (nonatomic, strong, readwrite) NSString *apiPath;
@property (nonatomic, strong, readwrite) NSData *bodyData;
@property (nonatomic, assign, readwrite) RequestType requestType;
@property (nonatomic, strong, readwrite) NSMutableURLRequest *request;
@property (nonatomic, assign, readwrite) NSUInteger retries;
@property (nonatomic, strong, readwrite) NSString *dateCreated;
@end

@implementation HSRequest

- (instancetype)initRequestWithAPI:(NSString *)apipath withType:(RequestType)type withDictionaryBody:(NSDictionary *)bodyDict headers:(NSDictionary *)headers{
    _dateCreated = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    return [self initWithRequestType:type WithAPI:apipath withBodyData:[self bodyDataFromDictionary:bodyDict requestType:type apiPath:apipath] headers:headers];
}

- (instancetype)initRequestWithAPI:(NSString *)apipath withType:(RequestType)type withStringBody:(NSString *)bodyString headers:(NSDictionary *)headers{
    _dateCreated = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    return [self initWithRequestType:type WithAPI:apipath withBodyData:[self bodyDataFromString:bodyString requestType:type apiPath:apipath] headers:headers];
}

- (instancetype)initWithRequestType:(RequestType)reqType WithAPI:(NSString *)apiPath withBodyData:(id)bodyData headers:(NSDictionary *)headers{
    if (self = [super init]) {
        [self validateHeaders:headers];
        [self validateAPIPath:apiPath];
        
        // Set Local Values
        _headers = headers;
        _bodyData = bodyData;
        _shouldParse = YES;
        _shouldShowErrorMessage = YES;
        _forceCacheRefresh = NO;
        _apiPath = [self apiPathWithUrlString:apiPath];
        
        if (bodyData && [bodyData isKindOfClass:[NSDictionary class]] && reqType == kHTTPRequestGET) {
            _apiPath = [NSString stringWithFormat:@"%@%@", _apiPath, [self queryURLString:bodyData]];
        }
        
        _requestType = reqType;
        _cacheType = kHSCacheNone;
        _maxRetryCount = 0;
        
        _request = [self urlRequestWithHeaders:headers bodyData:bodyData urlString:[self apiPath] httpMethod:reqType];
    }
    
    return self;
}


#pragma mark - API Request Validation

- (void)validateHeaders:(NSDictionary *)headers{
    if (headers && ![headers isValid]) {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ : %@", _apiPath, NSStringFromClass([self class])] reason:[NSString stringWithFormat:@"Headers are of Type %@. It should be of type dictionary.", NSStringFromClass([headers class])] userInfo:nil];
    }
}

- (void)validateAPIPath:(NSString *)apiPath{
    if (![apiPath isNonEmpty]) {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ : %@", _apiPath, NSStringFromClass([self class])] reason:@"API Path is Mandatory." userInfo:nil];
    }
}

#pragma mark - Create Request

- (NSStringEncoding)urlStringEncoding{
    return NSUTF8StringEncoding;
}

- (NSStringEncoding)requestBodyEncoding{
    return NSUTF8StringEncoding;
}

- (NSMutableURLRequest *)urlRequestWithHeaders:(NSDictionary *)headers bodyData:(id)bodyData urlString:(NSString *)urlString httpMethod:(RequestType)httpMethod{
    NSMutableURLRequest *request  = [NSMutableURLRequest new];
    
    [request setURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:[self requestStringForRequestType:httpMethod]];
    
    if (bodyData && [bodyData isKindOfClass:[NSData class]]) {
        [self setBody:bodyData onRequest:request];
    }
    
    [request setAllHTTPHeaderFields:[self headerWithDefaultValuesAddedToParamHeaders:headers andBodyData:bodyData]];
    [request setTimeoutInterval:kRequestTimeout];
    
    return request;
}

- (void)setBody:(NSData *)bodyData onRequest:(NSMutableURLRequest *)request{
    if (!bodyData) {
        return;
    }
    [request setHTTPBody:bodyData];
}

- (NSDictionary *)headerWithDefaultValuesAddedToParamHeaders:(NSDictionary *)headers andBodyData:(id)data{
    
    // Dictionary With Default Headers
    NSMutableDictionary *defaultHeader = [[NSMutableDictionary alloc] initWithDictionary:[self defaultHeaders]];
    
    // Add Request ID Timestamp header
    [defaultHeader addEntriesFromDictionary:[self requestIdCommonHeader]];
    
    if (data != nil && [data isKindOfClass:[NSData class]]) {
//        NSData *keyData = [HSHashKey dataFromHexString];
//
//        NSData *hashedData = [data SHA256Hash];
//        NSString *hashedString = [hashedData hexString];
//        NSData *hashedHexData = [hashedString dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *encryptedHashData = [hashedHexData AES128EncryptedDataWithKey:keyData];
//        NSData *base64EncryptedData = [encryptedHashData base64EncodedDataWithOptions:0];
        NSString *encryptedHashString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (encryptedHashString) {
//            [defaultHeader setObject:encryptedHashString forKey:HSRequestHeaderkey];
        }
    }
    // Add Param Header
    [defaultHeader addEntriesFromDictionary:headers];
    
    return defaultHeader;
}

- (NSString *)requestStringForRequestType:(RequestType)requestType{
    NSString *httpMethod = nil;
    
    switch (requestType) {
            case kHTTPRequestGET:
            httpMethod = @"GET";
            break;
            case kHTTPRequestPOST:
            httpMethod = @"POST";
            break;
            case kHTTPRequestDELETE:
            httpMethod = @"DELETE";
            break;
            case kHTTPRequestPUT:
            httpMethod = @"PUT";
            break;
            case kHTTPRequestOPTIONS:
            httpMethod = @"OPTIONS";
            break;
    }
    return httpMethod;
}

- (id)bodyDataFromDictionary:(NSDictionary *)dict requestType:(RequestType)requestType apiPath:(NSString *)apiPath{
    _uniqueKey = [[self uniqueKeyFromAPIPath:apiPath body:dict] stringByAppendingString:[NSString stringWithFormat:@"%@%@",kCacheDelimiter, [self dateCreated]]];
    return nil;
}

- (id)bodyDataFromString:(NSString *)bodyString requestType:(RequestType)requestType apiPath:(NSString *)apiPath{
    _uniqueKey = [[self uniqueKeyFromAPIPath:apiPath body:bodyString] stringByAppendingString:[NSString stringWithFormat:@"%@%@",kCacheDelimiter, [self dateCreated]]];
    return [bodyString dataUsingEncoding:[self requestBodyEncoding]];
}

- (NSString *)apiPathWithUrlString:(NSString *)urlString{
    if ([urlString rangeOfString:@"http"].location != NSNotFound) {
        return urlString;
    }
    else{
        // Append base URL
        return [NSString stringWithFormat:@"%@%@", @"url", urlString];
    }
}

- (NSString *)queryURLString:(NSDictionary *)dict{
    NSString *queryString = @"?";
    
    NSArray *keys = [NSArray arrayWithArray:[dict allKeys]];
    
    uint32_t keyCount = 0;
    for (NSString *key in keys) {
        if (keyCount == 0) {
            queryString = [NSString stringWithFormat:@"%@%@=%@", queryString, key, [dict objectForKey:key]];
        }
        else{
            queryString = [NSString stringWithFormat:@"%@&%@=%@", queryString, key, [dict objectForKey:key]];
        }
        keyCount++;
    }
    return queryString;
}

- (NSString *)uniqueKeyFromAPIPath:(NSString *)apiPath body:(id)body{
    NSString *apiPathWithBody = apiPath;
    if ([body isKindOfClass:[NSDictionary class]]) {
        apiPathWithBody = [apiPathWithBody stringByAppendingString:[self queryURLString:body]];
    }
    else if ([body isKindOfClass:[NSString class]]){
        apiPathWithBody = [apiPathWithBody stringByAppendingString:body];
    }
    return [apiPathWithBody stringByRemovingCharacterPattern:kIgnoreCharectersInCacheKey withString:@""];
}

#pragma mark - Default Headers

- (void)setHeaderValue:(NSString *)headerValue forKey:(NSString *)key{
    [[self request] setValue:headerValue forHTTPHeaderField:key];
}

- (void)addAuthorizationheader:(NSString *)authAheader toRequest:(NSMutableURLRequest *)request{
    [request setValue:[NSString stringWithFormat:@"Basic %@", authAheader] forHTTPHeaderField:@"Authorization"];
}

- (NSString *)authorizationHeaderWithUsername:(NSString *)username password:(NSString *)password{
    NSData *authCredentials = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [authCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    return base64AuthCredentials;
}

- (void)setShouldAddAuthHeaders:(BOOL)shouldAddAuthHeaders{
    _shouldAddAuthHeaders = shouldAddAuthHeaders;
    
    if (_shouldAddAuthHeaders) {
        [self addAuthorizationheader:[self authorizationHeaderWithUsername:nil password:nil] toRequest:[self request]];
    }

    
//    if (_shouldAddAuthHeaders) {
//        [self addAuthorizationheader:[self authorizationHeaderWithUsername:getApiKey() password:getClientSecret()] toRequest:[self request]];
//    }
}

- (void)addClientID:(NSString *)clientID forHeader:(NSString *)header toRequest:(NSMutableURLRequest *)request{
    [request setValue:clientID forHTTPHeaderField:header];
}

- (void)setShouldAddClientID:(BOOL)shouldAddClientID{
    _shouldAddClientID = shouldAddClientID;
    
    if (_shouldAddClientID) {
        //[self addClientID:getApiKey() forHeader:@"client_id" toRequest:[self request]];
    }
    else{
        [[self request] setValue:nil forHTTPHeaderField:@"client_id"];
    }
}

- (NSDictionary *)requestIdCommonHeader{
    // Add Customer ID related Headers compulsorily
//    if ([[HSUserModel customerId] isNonEmpty]) {
//        double milliseconds = [[NSDate date] timeIntervalSince1970] * 1000.f;
//        return @{kRequestHeader_X_REQUEST_ID: [NSString stringWithFormat:@"%@:%0.0lf", [HSUserModel customerId], milliseconds]};
//    }
    return nil;
}

- (NSDictionary *)defaultHeaders{
//    NSMutableDictionary *_defaultHeaders = [NSMutableDictionary dictionaryWithDictionary:@{kRequestHeader_ContentType:[self contentType], kRequestHeader_API_Key:getApiKey(), kRequestHeader_X_Forwarded_Host_API_Key:[Configuration getXForwardedHostApiKey]}];
    
//    NSMutableDictionary *_defaultHeaders = [NSMutableDictionary dictionaryWithDictionary:@{kRequestHeader_ContentType:[self contentType], kRequestHeader_API_Key:@"", kRequestHeader_X_Forwarded_Host_API_Key:@""}];
    NSMutableDictionary *_defaultHeaders = [NSMutableDictionary dictionaryWithDictionary:@{kRequestHeader_ContentType:[self contentType]}];

    return _defaultHeaders;
}

- (void)setTimeout:(NSTimeInterval)timeout{
    // The Timeout interval can only be set if it's greater than
    // minimum required timeout
    if (timeout >= kRequestMinTimeout) {
        [[self request] setTimeoutInterval:timeout];
    }
}

- (void)setShouldRemoveAPIKey:(BOOL)shouldRemoveAPIKey{
    _shouldRemoveAPIKey = shouldRemoveAPIKey;
    if (shouldRemoveAPIKey) {
        [[self request] setValue:nil forHTTPHeaderField:kRequestHeader_API_Key];
    }
}

- (void)setContentType:(NSString *)contentType{
    [[self request] setValue:contentType forHTTPHeaderField:kRequestHeader_ContentType];
}

- (ResponseType)responeType{
    return kHTTPResponseJSON;
}

#pragma Retry

- (void)setMaxRetryCount:(NSInteger)maxRetryCount{
    if (maxRetryCount <= 0) {
        maxRetryCount = 0;
    }
    _maxRetryCount = maxRetryCount;
}

- (void)retryStarted{
    _retries += 1;
}

@end
