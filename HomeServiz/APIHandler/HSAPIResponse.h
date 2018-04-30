//
//  HSAPIResponse.h
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSResult.h"
#import "HSRequest.h"

@interface HSAPIResponse : HSResult

- (instancetype)initWithRequest:(HSRequest *)request responseData:(id)responseData urlResponse:(NSURLResponse *)urlResponse error:(NSError *)error;
- (void)setShouldShowErrorMessage:(BOOL)show;

// Read
@property (strong, nonatomic, readonly) NSURLResponse *urlResponse;
@property (assign, nonatomic, readonly) BOOL shouldShowErrorMessage;

// Write
@property (assign, nonatomic) NSInteger tag;

@end
#import "HSAPIResponse+Utility.h"

