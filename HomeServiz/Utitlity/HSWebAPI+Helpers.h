//
//  HSWebAPI+Helpers.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSWebAPI.h"
#import "HSAPIResponse.h"
#import "HSRequest.h"

@interface HSWebAPI (Helpers)
+ (HSAPIResponse *)parseWithResponse:(id)response
                             request:(HSRequest *)request
                         urlResponse:(NSURLResponse *)urlResponse
                               error:(NSError *)error;

+ (BOOL)recognizeIfSuccessResponseWithResponse:(HSAPIResponse *)response;

@end
