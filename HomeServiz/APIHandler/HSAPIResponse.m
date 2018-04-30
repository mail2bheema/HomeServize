//
//  HSAPIResponse.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSAPIResponse.h"

@implementation HSAPIResponse
- (instancetype)initWithRequest:(HSRequest *)request responseData:(id)responseData urlResponse:(NSURLResponse *)urlResponses error:(NSError *)error{
    
    if (!responseData) {
        // To ensure that the Response is not nil
        responseData = [NSDictionary dictionary];
    }
    
    [self setErrorResponse:error];
    
    // Handling array in response.
    if ([responseData isKindOfClass:[NSArray class]]) {
        responseData = [NSDictionary dictionaryWithObject:responseData forKey:@"responseArray"];
    }
    
    if (request.shouldParse) {
        
        if (self = [super initWithDictionary:responseData error:nil]) {
            [self extractInfoFromURLResponse:urlResponses];
        }
    }
    else{
        if (self = [super init]) {
            [self extractInfoFromURLResponse:urlResponses];
        }
    }
    
    if ([request saveResponse]) {
        [self setResponseBody:responseData];
    }
    
    [self setMessage:[self extractMessageFromResponse]];
    
    return self;
}

- (void)extractInfoFromURLResponse:(NSURLResponse *)urlResponse{
    _urlResponse = urlResponse;
    
    [self setHttpStatusCode:[(NSHTTPURLResponse *)urlResponse statusCode]];
}

- (void)setShouldShowErrorMessage:(BOOL)show{
    _shouldShowErrorMessage = show;
}

@end
