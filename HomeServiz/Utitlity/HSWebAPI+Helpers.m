//
//  HSWebAPI+Helpers.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSWebAPI+Helpers.h"

@implementation HSWebAPI (Helpers)
#pragma mark - Parse

+ (HSAPIResponse *)parseWithResponse:(id)response
                             request:(HSRequest *)request
                         urlResponse:(NSURLResponse *)urlResponse
                               error:(NSError *)error{
    HSAPIResponse *parsedResponse = [[[request parserClass] alloc] initWithRequest:request
                                                                      responseData:response
                                                                       urlResponse:urlResponse error:error];
    return parsedResponse;
}

+ (BOOL)recognizeIfSuccessResponseWithResponse:(HSAPIResponse *)response{
    BOOL success = NO;
    
    if (response.httpStatusCode == 200) {
        success = YES;
    }
    
    if (response.code == HSResultResponseChecksumMismatch) {
        success = NO;
        
    } else if (response.code == HSResultCodeJWTValidationFailed) {
        success = NO;
    }
    
    if ([response errorResponse]) {
        success = NO;
    }
    
    if (([response status] && ([[response status] caseInsensitiveCompare:@"failure"] == NSOrderedSame || [[response status] caseInsensitiveCompare:@"failed"] == NSOrderedSame))) {
        success = NO;
    }
    
    return success;
}

@end
