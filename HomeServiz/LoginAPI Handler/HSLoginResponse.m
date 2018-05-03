//
//  HSLOginResponse.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSLoginResponse.h"


@implementation HSLoginResponse
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"uid":@"id",@"ustatus":@"status"}];
}

@end
