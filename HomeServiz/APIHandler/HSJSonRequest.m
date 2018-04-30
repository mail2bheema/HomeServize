//
//  HSJSonRequest.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSJSonRequest.h"

@implementation HSJSonRequest

- (id)bodyDataFromDictionary:(NSDictionary *)dict requestType:(RequestType)requestType apiPath:(NSString *)apiPath{
    [super bodyDataFromDictionary:dict requestType:requestType apiPath:apiPath];
    
    if (([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSArray class]]) && requestType != kHTTPRequestGET) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        return jsonData;
    }
    else if (dict && [dict isKindOfClass:[NSDictionary class]] && requestType == kHTTPRequestGET){
        return dict;
    }
    return nil;
}

- (ResponseType)responeType{
    return kHTTPResponseJSON;
}

- (NSString *)contentType{
    return @"application/json";
}

@end
