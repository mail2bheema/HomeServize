//
//  HSRequest.h
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPResponseSerializer;

typedef NS_ENUM(NSUInteger, RequestType) {
    kHTTPRequestGET,
    kHTTPRequestPOST,
    kHTTPRequestDELETE,
    kHTTPRequestPUT,
    kHTTPRequestOPTIONS
};

typedef NS_ENUM(NSUInteger, ResponseType) {
    kHTTPResponseJSON,
    kHTTPResponseXML
};

// kHSCacheDefault is Equal to kHSCacheOneMinute
typedef NS_ENUM(NSUInteger, HSCacheType) {
    kHSCacheNone,
    kHSCacheDefault,
    kHSCacheThirtySeconds,
    kHSCacheOneMinute,
    kHSCacheTwoMinutes,
    kHSCacheFiveMinutes,
    kHSCacheTenMinutes,
    kHSCacheOneHour,
    kHSCacheADay
};

static NSTimeInterval const kRequestTimeout = 60.0f;
static NSTimeInterval const kRequestMinTimeout = 20.0f;


@interface HSRequest : NSObject
#pragma mark - Constructors

- (instancetype)initRequestWithAPI:(NSString *)apipath withType:(RequestType)type withDictionaryBody:(NSDictionary *)bodyDict headers:(NSDictionary *)headers;
- (instancetype)initRequestWithAPI:(NSString *)apipath withType:(RequestType)type withStringBody:(NSString *)bodyString headers:(NSDictionary *)headers;

- (NSStringEncoding)urlStringEncoding;
- (NSStringEncoding)requestBodyEncoding;
- (id)bodyDataFromDictionary:(NSDictionary *)dict requestType:(RequestType)requestType apiPath:(NSString *)apiPath;
- (ResponseType)responeType;
- (void)setBody:(NSData *)bodyData onRequest:(NSMutableURLRequest *)request;
- (void)setHeaderValue:(NSString *)headerValue forKey:(NSString *)key;
- (NSString *)queryURLString:(NSDictionary *)dict;
- (void)retryStarted;

#pragma mark - Properties
#pragma mark - Read

@property (nonatomic, strong, readonly) NSString *uniqueKey;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSString *apiPath;
@property (nonatomic, strong, readonly) NSData *bodyData;
@property (nonatomic, assign, readonly) RequestType requestType;
@property (nonatomic, strong, readonly) NSMutableURLRequest *request;
@property (nonatomic, assign, readonly) NSTimeInterval requestStartTime;
@property (nonatomic, assign, readonly) NSTimeInterval requestEndTime;
@property (nonatomic, assign, readonly) NSUInteger retries;

#pragma mark - Write
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) AFHTTPResponseSerializer *serializer;
@property (assign, nonatomic) NSInteger maxRetryCount;
@property (nonatomic, assign) HSCacheType cacheType;
@property (nonatomic, assign) Class parserClass;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (nonatomic, assign) BOOL shouldParse;
@property (nonatomic, assign) BOOL shouldAddAuthHeaders;
@property (nonatomic, assign) BOOL shouldRemoveAPIKey;
@property (nonatomic, assign) BOOL shouldAddClientID;
@property (assign, nonatomic) BOOL saveResponse;
@property (assign, nonatomic) BOOL shouldShowErrorMessage;
@property (assign, nonatomic) BOOL shouldVerifyJWT;
@property (assign, nonatomic) BOOL forceCacheRefresh;

@end

