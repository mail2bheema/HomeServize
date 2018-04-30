//
//  HSTask.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSRequest.h"
#import "HSAPIResponse.h"
#import "HSNetworkProtocols.h"

typedef void (^ResponseBlock)(HSRequest *request, HSAPIResponse *response, id responseData);
typedef void (^TaskBlock)(HSRequest *request, id responseData, NSError *err, NSURLResponse *response);

@interface HSTask : NSObject

#pragma mark - Init method

- (instancetype)initWithRequest:(HSRequest *)request delegate:(id <HSAPIDelegate>)delegate responseReceivedBlock:(TaskBlock)responseReceivedBlock;
- (void)startNetworkTask;
- (void)stopNetworkTask;

@end
