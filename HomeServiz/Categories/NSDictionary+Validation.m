//
//  NSDictionary+Validation.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "NSDictionary+Validation.h"

@implementation NSDictionary(Validation)

- (BOOL)isValid{
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

@end
