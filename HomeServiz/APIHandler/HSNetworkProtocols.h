
//
//  HSNetworkProtocols.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HSRequest;
@class HSAPIResponse;

@protocol HSAPIDelegate <NSObject>
@optional
- (void)requestDidFinish:(HSRequest *)request withResponse:(HSAPIResponse *)response;
- (void)requestDidFail:(HSRequest *)request withErrorResponse:(HSAPIResponse *)response;

@end

@interface HSNetworkProtocols : NSObject

@end
